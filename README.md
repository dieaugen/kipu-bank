
# Kipu-Bank



## Deploy final en Sepoia Test:

  

https://eth-sepolia.blockscout.com/tx/0xa1b1ee4b2fdf813fa365cb788b3bab7021e91581255746ceb2e39b92e1f05f75

https://sepolia.etherscan.io/tx/0xa1b1ee4b2fdf813fa365cb788b3bab7021e91581255746ceb2e39b92e1f05f75

## Descripción de la tarea y requisitos del Trabajo:

Tu tarea es recrear el smart contract KipuBank con toda su funcionalidad y documentación, como se describe a continuación.
#### Características de KipuBank:
    - Los usuarios pueden depositar tokens nativos (ETH) en una bóveda personal.
    - Los usuarios pueden retirar fondos de su bóveda, pero solo hasta un umbral fijo por transacción, representado por una variable immutable.
    - El contrato impone un límite global de depósitos (bankCap), definido durante el despliegue.
    - Las interacciones internas y externas deben seguir buenas prácticas de seguridad y declaraciones revert con errores personalizados si no se cumplen las condiciones.
    - Se deben emitir eventos tanto en depósitos como en retiros exitosos.
    - El contrato debe llevar registro del número de depósitos y retiros.
    - El contrato debe tener al menos una función external, una private y una view.
#### Prácticas de seguridad a seguir:
    - Usar errores personalizados en lugar de cadenas en require.
    - Respetar el patrón checks-effects-interactions y las convenciones de nombres.
    - Usar modificadores donde corresponda para validar la lógica.
    - Manejar transferencias nativas de manera segura.
    - Mantener las variables de estado limpias, legibles y bien comentadas.
    - Agregar comentarios NatSpec para cada función, error y variable de estado.
    - Aplicar convenciones de nombres adecuadas.

#### Despliegue contrato en Remix

Estando en Remix se importa el archivo "KipuBank.sol" en nuevo proyecto.


![](./img/img01.png)

Para hacer le deploy  del contrato  en la red de Sepolia se selecciona "Deploy &Run Transactions:

![](./img/img02.png)

Se debe inicializar con valores adecuados y luego "transact": 

![](./img/img03.png)

Si se hizo el deploy correctamente debe aparecer abajo de todo:

![](./img/img04.png)

Para hacer pruebas solo se debe setear el valor de deposito o extraccion y hacer click en los botones visibles:

![](./img/img05.png)

Cualquier operacion exitosa o con errores se observa en la caja de mensajes de Debug:

![](./img/img06.png)