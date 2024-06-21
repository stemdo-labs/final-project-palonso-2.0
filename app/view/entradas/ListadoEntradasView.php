<!DOCTYPE html>
<html>
<head>
    <title>Listado de entradas</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="vista/css/sytles.css">
</head>
<body>
    <div class="container">
        <h1 class="text-center">LISTADO DE ENTRADAS</h1>
        <table>
            <tr>
                <th>Fecha</th>
                <th>Nombre</th>
                <th>Teléfono</th>
                <th>Tipo</th>
                <th>Cantidad</th>
                <th>Precio</th>
            </tr>
            <?php
            // Comprobamos que las variables con los datos no estén vacías
            if(!empty($datosEntrada) && !empty($datosTipoEntrada)) {
                // Recorremos el array con los datos de las entradas
                foreach($datosEntrada as $dE) {
                    echo '<tr>';
                    // Formateamos la fecha
                    $fecha = new DateTime($dE['fecha']);
                    echo '<td>' . date_format($fecha, 'd/m/Y') . '</td>';
                    echo '<td>' . $dE['nombre'] . ' ' . $dE['apellidos'] . '</td>';
                    echo '<td>' . $dE['telefono'] . '</td>';
                    echo '<td>';
                    // Buscamos el tipo de entrada correspondiente en los datos de tipo de entrada
                    foreach ($datosTipoEntrada as $dT) {
                        if($dT['id'] == $dE['tipo_entrada']) {
                            echo $dT['tipo'];
                        }
                    }
                    echo '</td>';
                    echo '<td>' . $dE['cantidad'] . '</td>';
                    echo '<td>';
                    // Calculamos el precio total
                    foreach ($datosTipoEntrada as $dT) {
                        if($dT['id'] == $dE['tipo_entrada']) {
                            echo $dT['precio'] * $dE['cantidad'];
                        }
                    }
                    echo '</td>';
                    echo '</tr>';
                }
            } else {
                echo '<tr><td colspan="6"><h3>No existe ningún registro en la base de datos</h3></td></tr>';
            }
            ?>
        </table>
        <a href="index.php?controlador=entradas&action=add"><button class="botonAceptar">Comprar entradas</button></a> 
    </div>  
</body>
</html>
