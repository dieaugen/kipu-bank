// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title KipuBank 
 * @author José
 * @dev KipuBank manager
 */
contract KipuBank {

    // @notice Límite máximo de retiro por transacción
    uint256 public immutable limitMaxRetiroWei;
    // @notice Límite de total Eth en depósitos en el banoc    
    uint256 public immutable bankCap;

    //@notice Contador de Despositos totales realizadas por sus clientes
    uint256 public countTotalDepositos;
    
    //@notice Contador de extacciones totales realizadas por sus clientes
    uint256 public countTotalExtracciones;
    
    //@notice Almacena la liquidez actual del banco
    uint256 public totalBancoBalanceWei; 

    /// @notice  Informacion sobre las operaciones de cada usuario
    struct UserInfo{
        uint256 balance;
        uint256 cantdepositos;
        uint256 cantretiros;
    }
    mapping ( address => UserInfo ) private _users;
    

   
    // @notice ErrRetiroExcedeLimite error cuando el retiro se excede el límite permitido.
    error ErrRetiroExcedeLimite(uint256 limite);
    
    // @notice ErrBalanceUsuarioInsuficiente  cuando no hay suficiente en la cuenta.
    error ErrBalanceUsuarioInsuficiente(uint256 monto, uint256 balance);
    
    // @notice ErrDepositoExcedeLimite error cuando se excede el maximo total permitido del banco (bankCap).
    error ErrDepositoExcedeLimite(uint256 monto, uint256 totalactual, uint256 maxbanco );
    
    // notice ErrMontoCero cuando el monto ingresado es igual a cero duh!!
    error ErrMontoCero();
    
    // @notice TransferFailed error cuando la transferencia falla o error generico.
    error ErrContractFailed();

    

    // @notice Mientras el valor a depositar es mayor que cero
    modifier montoValido() {
        if (msg.value == 0) revert ErrMontoCero();
        //require(msg.value > 0, "Monto invalido o igual a cero");
        _;
    }
    
    /** 
        @notice Valida que el monto a depositar no sea mayor que el BankCap.
        @dev BankCap es el limite maximo del banco.
        
        Tecnicamente esta funcion es identica ala que esta dentro de _depositar() pero sin sumar
        el balance total del banco. La dejo para mayor completitud __"completness"__ del Trabajo Final.
    */
    modifier noExcedeLimiteBankCap(){ 
        if ( msg.value  > bankCap) {
            revert ErrDepositoExcedeLimite( msg.value, totalBancoBalanceWei, bankCap); 
        }
        _;
    }

    //  @notice Valida que el monto introducido no exceda el limite maximo de retiro por TX
    modifier noExcedeLimiteExtraccion(){ 
        if ( msg.value > limitMaxRetiroWei) {
            revert ErrRetiroExcedeLimite( limitMaxRetiroWei); 
        }
        _;
    }    

    /**
     * @notice Deposito relizado correctamente.
     * @param user addr del usuario.
     * @param monto   Monto depositado (wei).
     * @param balanceUsuario Balance total del Usuario.
     * @param balanceBanco Balance total del Banco.
     */
    event Deposito(address indexed user, uint256 monto, uint256 balanceUsuario, uint256 balanceBanco);

     /**
     * @notice Retiro exitoso por parte de un usuario.
     * @param user Dirección del usuario que retiró.
     * @param monto   Monto retirado en wei.
     * @param balanceUsuario Balance total del Usuario.
     * @param balanceBanco Balance total del Banco.
     */
    event Retiro(address indexed user, uint256 monto, uint256 balanceUsuario, uint256 balanceBanco);


    /**
        @notice Inicializacion del contrato.
        @dev Inicializa las variables inmutables
    */
    constructor(uint256 _bankCap, uint256 _withdrawLimit) {
        if ( _bankCap == 0 || _withdrawLimit == 0 || _withdrawLimit > _bankCap) {
            revert ErrContractFailed();
        }
        bankCap = _bankCap;
        limitMaxRetiroWei = _withdrawLimit;
    }

    // @notice Define como default Depostar Wei
    receive() external payable { 
        _depositar(msg.sender, msg.value);
    }

    // @notice informo del fallo del contrato. 
    // @dev Podria haber sido _depositar() como default también.
    fallback() external payable { 
        revert ErrContractFailed();
    }

    // @notice Deposita ETH en la bóveda del remitente.
    // @dev
    function Depositar() external payable  {
        _depositar(msg.sender, msg.value);        
    }

    /** 
        @notice Funcion privada encargade de realizar el deposito
        @param _cuenta addrs del usuario
        @param _monto monto a depositar
    */ 
    function _depositar(address _cuenta, uint256 _monto) private montoValido noExcedeLimiteBankCap {
        if ( totalBancoBalanceWei + _monto > bankCap) {
            revert ErrDepositoExcedeLimite(_monto, totalBancoBalanceWei, bankCap ); 
        }
        
        //Balance por usuario:
        _users[_cuenta].balance += _monto;
        _users[_cuenta].cantdepositos ++;
        
        //Balance Banco:
        totalBancoBalanceWei += _monto;
        countTotalDepositos++;


        emit Deposito(_cuenta, _monto, _users[_cuenta].balance, totalBancoBalanceWei);
    }


    /**
        @notice Retira Weis de la bóveda del usuario, verifica límites por transacción.
     */
    function Retirar() external payable  { 
        _retirar(msg.sender, msg.value);            
    }

    /** 
        @notice Funcion privada del retiro de Weis del banco
        @param _cuenta addrs del usuario
        @param _monto monto a depositar
    */ 
    function _retirar(address _cuenta, uint256 _monto) private montoValido  noExcedeLimiteExtraccion{

        // El usuario debe tener liquidez:
         if (_users[ _cuenta ].balance < _monto) {
            revert ErrBalanceUsuarioInsuficiente(_monto, _users[ _cuenta ].balance);
        }
        
        _users[_cuenta].balance -= _monto;
        _users[_cuenta].cantretiros ++;

        totalBancoBalanceWei -= _monto;
        countTotalExtracciones++;

        // @TODO: hacer _tranferrir mediante msg.sender.call() 
        //_transferir(payable(_addr), _monto);


        emit Retiro(_cuenta, _monto, _users[_cuenta].balance, totalBancoBalanceWei);
    }
    

    /**  
        @notice Vista del balance de un usuario
        @param _cuenta usuario
        @return total balance en Wei
    */
    function getBalanceCuenta(address _cuenta) external view returns (uint256) {
        return _users[_cuenta].balance;
    }

    
}