// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Disney is ERC20, Ownable{
    
    // ============================================
    // Initial Statements
    // ============================================
    
    // Constructor 
    constructor() ERC20("Disney", "JA") {
        _mint(address(this), 1000);
    }
    
    // Estructura de datos para almacenar a los clientes de Disney
    struct cliente {
        uint tokens_comprados;
        string [] atracciones_disfrutadas;
    }
    
    // Mapping para el registro de clientes
    mapping (address => cliente) public Clientes;
    
    // ============================================
    // Token Management
    // ============================================

    // Funcion para establecer el precio de un Token 
    function PrecioTokens(uint _numTokens) internal pure returns (uint) {
        // Conversion de Tokens a Ethers: 1 Token -> 1 ether
        return _numTokens*(1 ether);
    }
    
    // Funcion para comprar Tokens en disney y disfrutar de las atracciones 
    function CompraTokens(uint _numTokens) public payable {
        // Establecer el precio de los Tokens
        uint coste = PrecioTokens(_numTokens);
        // Se evalua el dinero que el cliente paga por los Tokens
        require (msg.value >= coste, "Compra menos Tokens o paga con mas ethers.");
        // Diferencia de lo que el cliente paga
        uint returnValue = msg.value - coste;
        // Disney retorna la cantidad de ethers al cliente
        payable(msg.sender).transfer(returnValue);
        // Obtencion del numero de tokens disponibles
        uint Balance = balanceTokens(address(this));
        require(_numTokens <= Balance, "Compra un numero menor de Tokens");
        // Se transfiere el numero de tokens al cliente
        _transfer(address(this), msg.sender, _numTokens);
        increaseAllowance(msg.sender, _numTokens);
        // Registro de tokens comprados
        Clientes[msg.sender].tokens_comprados += _numTokens;
    }
    
    // Balance de tokens de una dirección
    function balanceTokens(address _account) public view returns (uint) {
        return balanceOf(_account);
    }

    // Mint more tokens
    function mint(uint256 _amount) public onlyOwner{
        _mint(address(this), _amount);
    }

    // ============================================
    // Company management
    // ============================================

    // Eventos 
    event disfruta_atraccion(string, uint, address);
    event nueva_atraccion(string, uint);
    event baja_atraccion(string);
    
    // Estructura de la atraccion 
    struct atraccion {
        string nombre_atraccion;
        uint precio_atraccion;
        bool estado_atraccion;
    }
    
    // Mapping para relacion un nombre de una atraccion con una estructura de datos de la atraccion
    mapping (string => atraccion) public MappingAtracciones;
    
    // Array para almacenar el nombre de las atracciones 
    string [] public Atracciones;
    
    // Mapping para relacionar una identidad (cliente) con su historial de atracciones en DISNEY
    mapping (address => string []) public HistorialAtracciones;
    
    // Crear nuevas atracciones para DISNEY (SOLO es ejecutable por Disney)
    function NuevaAtraccion(string memory _nombreAtraccion, uint _precio) public onlyOwner {
        // Creacion de una atraccion en Disney 
        MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion,_precio, true);
        // Almacenamiento en un array el nombre de la atraccion 
        Atracciones.push(_nombreAtraccion);
        // Emision del evento para la nueva atraccion 
        emit nueva_atraccion(_nombreAtraccion, _precio);
    }
    
    // Dar de baja a las atracciones en Disney 
    function BajaAtraccion (string memory _nombreAtraccion) public onlyOwner{
        // El estado de la atraccion pasa a FALSE => No esta en uso 
        MappingAtracciones[_nombreAtraccion].estado_atraccion = false;
        // Emision del evento para la baja de la atraccion 
        emit baja_atraccion(_nombreAtraccion);
     }
    
    // Funcion para subirse a una atraccion de disney y pagar en tokens 
    function SubirseAtraccion (string memory _nombreAtraccion) public {
        // Precio de la atraccion (en tokens)
        uint tokens_atraccion = MappingAtracciones[_nombreAtraccion].precio_atraccion;
        // Verifica el estado de la atraccion (si esta disponible para su uso)
        require (MappingAtracciones[_nombreAtraccion].estado_atraccion == true, 
                    "La atraccion no esta disponible en estos momentos.");
        // Verifica el numero de tokens que tiene el cliente para subirse a la atraccion 
        require(tokens_atraccion <= balanceTokens(address(this)), 
                "Necesitas mas Tokens para subirte a esta atraccion.");
        _transfer(msg.sender, address(this), tokens_atraccion);
        // Almacenamiento en el historial de atracciones del cliente 
        HistorialAtracciones[msg.sender].push(_nombreAtraccion);
        // Emision del evento para disfrutar de la atraccion 
        emit disfruta_atraccion(_nombreAtraccion, tokens_atraccion, msg.sender);
    }

    // Funcion para que un cliente de Disney pueda devolver Tokens 
    function DevolverTokens (uint _numTokens) public payable {
        // El numero de tokens a devolver es positivo
        require (_numTokens > 0, "Necesitas devolver una cantidad positiva de tokens.");
        // El usuario debe tener el numero de tokens que desea devolver 
        require (_numTokens <= balanceTokens(msg.sender), "No tienes los tokens que deseas devolver.");
        // El cliente devuelve los tokens 
        _transfer(msg.sender, address(this), _numTokens);
         // Devolucion de los ethers al cliente 
         payable(msg.sender).transfer(PrecioTokens(_numTokens));
    }
    
}