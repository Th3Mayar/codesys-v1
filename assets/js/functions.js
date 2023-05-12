/*function actualizarHora(){
    $.get("../Include/functions.php", function(data) {
        $("#hora").html(data);
    });
}
actualizarHora();
setInterval(actualizarHora, 1000);*/

$(document).ready(function(){
    
    $('.btn_menu').click(function(e){
        e.preventDefault();
        if($('nav').hasClass('viewMenu')){
            $('nav').removeClass('viewMenu');
        }else{
            $('nav').addClass('viewMenu');
        }
    });

    $("#foto").on("change",function(){
    	var uploadFoto = document.getElementById("foto").value;
        var foto       = document.getElementById("foto").files;
        var nav = window.URL || window.webkitURL;
        var contactAlert = document.getElementById('form_alert');
        
            if(uploadFoto !='')
            {
                var type = foto[0].type;
                var name = foto[0].name;
                if(type != 'image/jpeg' && type != 'image/jpg' && type != 'image/png')
                {
                    contactAlert.innerHTML = '<p class="errorArchivo">El archivo no es válido.</p>';                        
                    $("#img").remove();
                    $(".delPhoto").addClass('notBlock');
                    $('#foto').val('');
                    return false;
                }else{  
                        contactAlert.innerHTML='';
                        $("#img").remove();
                        $(".delPhoto").removeClass('notBlock');
                        var objeto_url = nav.createObjectURL(this.files[0]);
                        $(".prevPhoto").append("<img id='img' src="+objeto_url+">");
                        $(".upimg label").remove();
                        
                    }
            }else{
                alert("No selecciono foto");
                $("#img").remove();
            }              
    });

    $('.delPhoto').click(function(){
    $('#foto').val('');
    $(".delPhoto").addClass('notBlock');
    $("#img").remove();

    });

    // Ventana modal de agregar productos
    $('.add_product').click(function(e){
        e.preventDefault();
        var producto = $(this).attr('product');
        var action = 'infoProducto';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, producto:producto},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    
                    $('#id_producto').val(info.Cod_Producto);
                    $('.name_producto').html(info.Nombre);
                    $('.bodyModal').html('<form action="" method="POST" name="form_add_product" id="form_add_product" onsubmit="event.preventDefault(); sedDataProduct();">'+
                                            '<h1 style="text-align:center"><i class="fas fa-cubes" style="font-size:45pt;"></i><br> Agregar producto</h1><br>'+
                                            '<h3 class="name_producto" style="text-align:center">'+info.Nombre+'</h3><br>'+
                                            '<input type="number" name="cantidad" id="txtcantidad" placeholder="Cantidad" required><br>'+
                                            '<input type="text" name="precio" id="txtprecio" placeholder="Precio" required>'+
                                            '<input type="hidden" name="id_producto" id="id_producto" value="'+info.Cod_Producto+'" required>'+
                                            '<input type="hidden" name="action" id="action" value="addProduct" required>'+
                                            '<div class="alertModal alertAddProduct"></div>'+
                                            '<button type="submit" class="btn_new" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;"><i class="fas fa-plus"></i> Agregar</button>'+
                                            '<a href="#" style="font-size:14px; background-color:rgb(218, 56, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                                        '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        
        $('.modal').fadeIn();
    });

    // Ventana modal de eliminar productos
    $('.del_product').click(function(e){
        e.preventDefault();
        var producto = $(this).attr('product');
        var action = 'infoProducto';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, producto:producto},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    
                    $('#id_producto').val(info.Cod_Producto);
                    $('.name_producto').html(info.Nombre);
                    $('.bodyModal').html('<form action="" method="POST" name="form_del_product" id="form_del_product" onsubmit="event.preventDefault(); sedDelProduct();">'+
                                            '<h1 style="text-align:center;"><i class="fas fa-cubes" style="font-size:45pt;"></i><br> Eliminar producto</h1>'+
                                            '<h4 style="text-align:center; color:#6d6c6c;"><br> ¿Deseas eliminar este producto?</h4><br>'+
                                            '<h3 class="name_producto" style="text-align:center">'+info.Nombre+'</h3><br>'+
                                            '<input type="hidden" name="id_producto" id="id_producto" value="'+info.Cod_Producto+'" required>'+
                                            '<input type="hidden" name="action" id="action" value="delProduct" required>'+
                                            '<div class="alertModal alertDelProduct"></div>'+
                                            '<a href="#" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                                            '<button type="submit" class="btn_new btn_eliminado" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-trash" style="color: #ffffff;"></i> Eliminar</button>'+
                                        '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        
        $('.modal').fadeIn();
    });

    // Ventana modal de eliminar usuario
    $('.del_user').click(function(e){
        e.preventDefault();
        var user = $(this).attr('user');
        var action = 'infoUser';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, user:user},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    $('#id_usuario').val(info.ID_Usuario);
                    $('.name_user').html(info.Usuario);
                    $('.bodyModal').html('<form action="" method="POST" name="form_del_user" id="form_del_user" onsubmit="event.preventDefault(); sedDelUser();">'+
                                            '<h1 style="text-align:center;"><i class="fa-solid fa-user-minus" style="font-size:45pt;"></i><br><br> Eliminar usuario</h1>'+
                                            '<h4 style="text-align:center; color:#6d6c6c;"><br> ¿Deseas eliminar este usuario?</h4><br>'+
                                            '<h3 class="name_user" style="text-align:center;">'+info.Nombre+'</h3><br>'+
                                            '<h5 class="name_user" style="text-align:center; color:#6d6c6c;"><b>Rol:</b> '+info.Rol+'</h5><br>'+
                                            '<input type="hidden" name="id_usuario" id="id_usuario" value="'+info.ID_Usuario+'" required>'+
                                            '<input type="hidden" name="action" id="action" value="delUser" required>'+
                                            '<div class="alertModal alertDelUser"></div>'+
                                            '<a href="#" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                                            '<button type="submit" class="btn_new btn_eliminado" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-trash" style="color: #ffffff;"></i> Eliminar</button>'+
                                        '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        
        $('.modal').fadeIn();
    });

    // Ventana modal de eliminar clientes
    $('.del_client').click(function(e){
        e.preventDefault();
        var client = $(this).attr('client');
        var action = 'infoClient';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, client:client},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    $('#id_cliente').val(info.ID_Cliente);
                    $('.name_client').html(info.Nombre);
                    $('.rnc_client').html(info.RNC);
                    $('.bodyModal').html('<form action="" method="POST" name="form_del_client" id="form_del_client" onsubmit="event.preventDefault(); sedDelClient();">'+
                                            '<h1 style="text-align:center;"><i class="fa-solid fa-user-minus" style="font-size:45pt;"></i><br><br> Eliminar cliente</h1>'+
                                            '<h4 style="text-align:center; color:#6d6c6c;"><br> ¿Deseas eliminar este cliente?</h4><br>'+
                                            '<h3 class="name_client" style="text-align:center;">'+info.Nombre+' '+info.Apellido+'</h3><br>'+
                                            '<h5 class="rnc_client" style="text-align:center; color:#6d6c6c;"><b>RNC:</b> '+info.RNC+'</h5><br>'+
                                            '<input type="hidden" name="id_cliente" id="id_cliente" value="'+info.ID_Cliente+'" required>'+
                                            '<input type="hidden" name="action" id="action" value="delClient" required>'+
                                            '<div class="alertModal alertDelClient"></div>'+
                                            '<a href="#" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                                            '<button type="submit" class="btn_new btn_eliminado" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-trash" style="color: #ffffff;"></i> Eliminar</button>'+
                                        '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        
        $('.modal').fadeIn();
    });

    // Ventana modal de eliminar clientes
    $('.del_supplier').click(function(e){
        e.preventDefault();
        var client = $(this).attr('client');
        var action = 'infoSupp';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, client:client},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    $('#id_proveedor').val(info.ID_Proveedor);
                    $('.name_proov').html(info.Proveedor);
                    $('.bodyModal').html('<form action="" method="POST" name="form_del_supplier" id="form_del_supplier" onsubmit="event.preventDefault(); sedDelSuppl();">'+
                                            '<h1 style="text-align:center;"><i class="fa-solid fa-truck-field" style="font-size:45pt;"></i><br> Eliminar proveedor</h1>'+
                                            '<h4 style="text-align:center; color:#6d6c6c;"><br> ¿Deseas eliminar este proveedor?</h4><br>'+
                                            '<h3 class="name_proov" style="text-align:center;">'+info.Proveedor+'</h3><br>'+
                                            '<h5 class="rnc_client" style="text-align:center; color:#6d6c6c;"><b>Contacto:</b> '+info.Contacto+'</h5><br>'+
                                            '<input type="hidden" name="id_proveedor" id="id_proveedor" value="'+info.ID_Proveedor+'" required>'+
                                            '<input type="hidden" name="action" id="action" value="delSupp" required>'+
                                            '<div class="alertModal alertDelSuppl"></div>'+
                                            '<a href="#" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                                            '<button type="submit" class="btn_new btn_eliminado" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-trash" style="color: #ffffff;"></i> Eliminar</button>'+
                                        '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        
        $('.modal').fadeIn();
    });

    $('#search_proveedor').change(function(e){
        e.preventDefault();
        var codesys = getUrl();
        location.href = codesys+'buscar_productos.php?proveedor='+$(this).val();
    })

    // Activar campos para registrar los clientes.
    $('.btn_new_cliente').click(function(e){
        e.preventDefault();
        $('#name').removeAttr('disabled');
        $('#apellido').removeAttr('disabled');
        $('#tel').removeAttr('disabled');
        $('#location').removeAttr('disabled');
        $('#email').removeAttr('disabled');

        $('#div_registro_cliente').slideDown();
    });

    // Buscar cliente en ventas
    $('#rnc').keyup(function(e){
        e.preventDefault();

        var cl = $(this).val();
        var action = 'searchCliente';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action,cliente:cl},

            success: function(response){

                if(response == 0){
                    $('#idcliente').val('');
                    $('#name').val('');
                    $('#apellido').val('');
                    $('#tel').val('');
                    $('#location').val('');
                    $('#email').val('');

                    // Mostrar boton de agregar cliente
                    $('.btn_new_cliente').slideDown();
                }else{
                    var data = $.parseJSON(response);
                    $('#idcliente').val(data.ID_Cliente);
                    $('#name').val(data.Nombre);
                    $('#apellido').val(data.Apellido);
                    $('#tel').val(data.Telefono);
                    $('#location').val(data.Direccion);
                    $('#email').val(data.Correo);
                    
                    // Ocultar boton agregar
                    $('.btn_new_cliente').slideUp();

                    // Bloque de campos
                    $('#name').attr('disabled','disabled');
                    $('#apellido').attr('disabled','disabled');
                    $('#tel').attr('disabled','disabled');
                    $('#location').attr('disabled','disabled');
                    $('#email').attr('disabled','disabled');

                    // Ocultar boton guardar
                    $('#div_registro_cliente').slideUp();
                };
            },

            error: function(error){
            }
        
        });

    });

    // Crear clientes, ventas
    $('#form_new_cliente_venta').submit(function(e){
        e.preventDefault();
        
        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: $('#form_new_cliente_venta').serialize(),

            success: function(response){
                
                if(response != '\r\nerror'){
                    // Agregar idcliente a input hidden
                    $('#idcliente').val(response);

                    $('#name').attr('disabled','disabled');
                    $('#apellido').attr('disabled','disabled');
                    $('#tel').attr('disabled','disabled');
                    $('#location').attr('disabled','disabled');
                    $('#email').attr('disabled','disabled');

                    // Ocultar boton de agregar
                    $('.btn_new_cliente').slideUp();

                    // Ocultar boton guardar
                    $('#div_registro_cliente').slideUp();
                }
            },

            error: function(error){
            }
        
        });
    });

    // Buscar producto de ventas
    $('#txt_cod_producto').keyup(function(e){
        e.preventDefault();

        var producto = $(this).val();
        var action = 'infoProducto';
        
        if(producto != ''){
            $.ajax({
                url: "ajax.php",
                type: "POST",
                async: true,
                data: {action:action, producto:producto},

                success: function(response){
                    if(response != '\r\nerror'){
                        var info = JSON.parse(response);
                        $('#txt_descripcion').html(info.Descripcion);
                        $('#txt_existencia').html(info.Cantidad);
                        $('#txt_cant_producto').val('1');
                        $('#txt_precio').html(info.Precio_Unitario);
                        $('#txt_precio_total').html(info.Precio_Unitario);

                        // Activar cantidad
                        $('#txt_cant_producto').removeAttr('disabled');

                        // Mostrar boton agregar
                        $('#add_product_venta').slideDown();

                    }else{
                        $('#txt_descripcion').html('-');
                        $('#txt_existencia').html('-');
                        $('#txt_cant_producto').val('0');
                        $('#txt_precio').html('0.00');
                        $('#txt_precio_total').html('0.00');


                        // Bloquear cantidad
                        $('#txt_cant_producto').attr('disabled','disabled');

                        // Ocultar boton agregar
                        $('#add_product_venta').slideUp();
                    }
                    
                },

                error: function(error){
                    
                }
            
            });
        }
    });

    // Validar cantidad del producto
    $('#txt_cant_producto').keyup(function(e){
        e.preventDefault();
        
        var precio_total = $(this).val() * $('#txt_precio').html();
        var cant_existencia = parseInt($('#txt_existencia').html());
        $('#txt_precio_total').html(precio_total);

        if(($(this).val() < 1 || isNaN($(this).val())) || ($(this).val() > cant_existencia)){
            $('#add_product_venta').slideUp();
            //$('#txt_precio_total').html('0.00');
        }else{
            $('#add_product_venta').slideDown();
        }
    });

    // Agregar productos a la t_detalle
    $('#add_product_venta').click(function(e){
        e.preventDefault();
        
        if($('#txt_cant_producto').val() > 0){
            var codproducto = $('#txt_cod_producto').val();
            var cantidad = $('#txt_cant_producto').val();
            var action = 'addProductoDetalle';
            // Ajax
            $.ajax({
                url: "ajax.php",
                type: "POST",
                async: true,
                data: {action:action, producto:codproducto, cantidad:cantidad},
                
                success: function(response){

                    if(response != 'error'){
                        var info = JSON.parse(response);
                        $('#detalle_venta').html(info.detalle);
                        $('#detalle_totales').html(info.totales);
                        
                        $('#txt_cod_producto').val('');
                        $('#txt_descripcion').html('-');
                        $('#txt_existencia').html('-');
                        $('#txt_cant_producto').val('0');
                        $('#txt_precio').html('0.00');
                        $('#txt_precio_total').html('0.00');

                        // Bloquear cantidad
                        $('#txt_cant_producto').attr('disabled','disabled');

                        // Ocultar boton agregar
                        $('#add_product_venta').slideUp();

                    }else{
                        console.log("Not data");
                    }

                    viewProcesar();

                },

                error: function(error){
                    
                }

            });
        }
    });

    // Anular venta
    $('#btn_anular_venta').click(function(e){
        e.preventDefault();
        
        var rows = $('#detalle_venta tr').length;

        if(rows > 0){
            var action = 'anularVenta';
        
        // Ajax
        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action},
            
            success: function(response){

                if(response != 'error'){
                    location.reload();
                }

                },
                
                error: function(error){
                    
                }
            });
            }
    });
    
    // Facturar venta
    $('#btn_facturar_venta').click(function(e){
        e.preventDefault();
        
        var rows = $('#detalle_venta tr').length;

        if(rows > 0){
            var action = 'procesarVenta';
            var codcliente = $('#idcliente').val();
        
        // Ajax
        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action,codcliente:codcliente},
            
            success: function(response){

                if(response != 'error'){
                    
                    var info = JSON.parse(response);
                    //console.log(info);
                    generarPDFSmall(info.Cod_cliente,info.ID_Factura);
                    //generarPDF(info.Cod_cliente,info.ID_Factura);
                    location.reload();

                }else{
                    console.log("Not data");
                }

                },
                
                error: function(error){
                    
                }
            });
            }
    });

    // Ventana modal de agregar categorias
    $('.add_category').click(function(e){
        e.preventDefault();

        $('.bodyModal').html('<form action="" method="POST" name="form_add_cat" id="form_add_cat" onsubmit="event.preventDefault(); sedDataCategory();">'+
                                '<h1 style="text-align:center"><i class="fa-solid fa-plus" style="color: #525151;"></i> Agregar Categoria</h1><br>'+
                                '<input type="text" name="txtNombre" id="txtNombre" placeholder="Nombre Categoria">'+
                                '<input type="text" name="txtdesc" id="txtdesc" placeholder="Descripcion">'+
                                '<input type="hidden" name="action" id="action" value="addCat" required>'+
                                '<div class="alertModal alertAddCat"></div>'+
                                '<button type="submit" class="btn_new" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;"><i class="fa-solid fa-floppy-disk" style="color: #ffffff;"></i> Guardar</button>'+
                                '<a href="#" style="font-size:14px; background-color:rgb(218, 56, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                            '</form>');
        
        $('.modal').fadeIn();
    });

    // Ventana modal de editar categorias
    $('.edit_cat').click(function(e){
        e.preventDefault();
        var id = $(this).attr('category');
        var action = 'infoCategory';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, id:id},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    $('#id_cat').val(info.ID_Categoria);
                    $('.bodyModal').html('<form action="" method="POST" name="form_edit_cat" id="form_edit_cat" onsubmit="event.preventDefault(); sedDataCat();">'+
                                '<h1 style="text-align:center"><i class="fa-solid fa-pen-to-square" style="color: #525151;"></i> Editar Categoria</h1><br>'+
                                '<input type="text" name="txtNombre" id="txtNombre" placeholder="Nombre Categoria" value="'+info.Nombre_Categoria+'">'+
                                '<input type="text" name="txtdesc" id="txtdesc" placeholder="Descripcion" value="'+info.Descripcion+'">'+
                                '<input type="hidden" name="id_cat" id="id_cat" value="'+info.ID_Categoria+'" required>'+
                                '<input type="hidden" name="action" id="action" value="EditCat" required>'+
                                '<div class="alertModal alertEditCat"></div>'+
                                '<button type="submit" class="btn_new" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;"><i class="fa-solid fa-floppy-disk" style="color: #ffffff;"></i> Guardar</button>'+
                                '<a href="#" style="font-size:14px; background-color:rgb(218, 56, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                            '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        $('.modal').fadeIn();
    });

    // Ventana modal de anular factura
    $('.anular_factura').click(function(e){
        e.preventDefault();
        var nofactura = $(this).attr('fac');
        var action = 'infoFactura';

        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action, nofactura:nofactura},
            
            success: function(response){
                if(response != 'error'){
                    var info = JSON.parse(response);
                    $('.bodyModal').html('<form action="" method="POST" name="form_anular_fact" id="form_anular_fact" onsubmit="event.preventDefault(); anularFactura();">'+
                                            '<h1 style="text-align:center;"><i class="far fa-newspaper" style="font-size:50pt;"></i><br> Anular factura</h1>'+
                                            '<h4 style="text-align:center; color:#6d6c6c;"><br> ¿Deseas anular esta factura?</h4><br>'+
                                            '<p><strong>No. '+info.ID_Factura+'</strong></p>'+
                                            '<p><strong>Monto. RD$'+info.Total_Factura+'</strong></p>'+
                                            '<p><strong>Fecha. '+info.Fecha+'</strong></p>'+
                                            '<input type="hidden" name="action" value="anularFactura">'+
                                            '<input type="hidden" name="no_factura" id="no_factura" value="'+info.ID_Factura+'" required>'+
                                            '<div class="alertModal alertNullFact"></div>'+
                                            '<button type="submit" class="btn_new btn_eliminado" style="background-color:rgb(218, 56, 56); color:#fff;"><i class="fa-solid fa-trash" style="color: #ffffff;"></i> Anular</button>'+
                                            '<a href="#" style="font-size:14px; background-color:rgb(63, 122, 56); color:#fff;" class="btn_new close_modal" onclick="closeModal(); event.preventDefault();"><i class="fa-solid fa-ban" style="color: #ffffff;"></i> Cerrar</a>'+
                                        '</form>');
                };
            },

            error: function(error){
                console.log(error);
            }
            
        });
        
        $('.modal').fadeIn();
    });

    // Ver factura 
    $('.view_factura').click(function(e){
        e.preventDefault();
        var codCliente = $(this).attr('cl');
        var noFactura = $(this).attr('f');
        var tipo_factura = $(this).attr('st');

        // Variables define el alto de la ventana para mostrar
        var ancho = 1000;
        var alto = 800;
        
        // Calcular posocion x,y para centrar la ventana
        var x = parseInt((window.screen.width/12) - (ancho / 12));
        var y = parseInt((window.screen.height/5) - (alto / 5));
            
        $url = 'Package/factura/factura_small.php?cl='+codCliente+'&f='+noFactura+'&t='+tipo_factura;
        // Posciones
        window.open($url,"Factura","left="+x+",top="+y+",height="+alto+",width="+ancho+",scrollbar=si,location=no,resizable=si,menubar=no");
    });

    // Cambiar password del usuario
    $('.newPass').keyup(function(){
        validPass();
    });

    // Formulario de cambio de pass
    $('#frmChangePass').submit(function(e){
        e.preventDefault();

        var passActual = $('#txtPassUser').val();
        var passNew = $('#txtNewPassUser').val();
        var confirmPass = $('#txtPassConfirm').val();
        var action = 'changePassword';

        if(passNew != confirmPass){
            $('.alertChangePass').html('<p style="color:red; font-size: 12px;">Las contraseñas no son iguales</p>');
            $('.alertChangePass').slideDown();
            return false;
        }
    
        if(passNew.length < 6){
            $('.alertChangePass').html('<p style="color:red; font-size: 12px;">La contraseña debe ser de 6 caracteres mínimo</p>');
            $('.alertChangePass').slideDown();
            return false;
        }

        // Ajax
        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: {action:action,passActual:passActual, passNew:passNew},
            
            success: function(response){

                if(response != 'error'){
                    var info = JSON.parse(response);

                    if(info.cod = '00'){
                        $('.alertChangePass').html('<p style="font-size: 12px;">'+info.msg+'</p>');
                        $('#frmChangePass')[0].reset();
                    }else{
                        $('.alertChangePass').html('<p style="font-size: 12px;">'+info.msg+'</p>');
                    }
                    $('.alertChangePass').slideDown();
                }
                setTimeout(function(){
                    location.reload();
                }, 3500);
            },
                
                error: function(error){
                    
                }
            });
    });

    // Formulario de actualizacion de empresa
    $('#frmEmpresa').submit(function(e){
        e.preventDefault();

        var intCif = $('#txtCif').val();
        var strNombre = $('#txtNombre').val();
        var strRazon = $('#txtRazon').val();
        var strTel = $('#txtTel').val();
        var strEmail = $('#txtEmail').val();
        var strDirecc = $('#txtDireccion').val();
        var intItbis = $('#txtItbis').val();

        if(intCif == '' || strNombre == '' || strTel == '' || strEmail == '' || strDirecc == '' || intItbis == ''){
            $('.alertFormEmpresa').html('<p style="color:red; font-size: 12px;">Todos los campos son obligatorios</p>');
            $('.alertFormEmpresa').slideDown();
            return false;
        }

        // Ajax
        $.ajax({
            url: "ajax.php",
            type: "POST",
            async: true,
            data: $('#frmEmpresa').serialize(),
            beforeSend: function(){
                $('.alertFormEmpresa').slideUp();
                $('.alertFormEmpresa').html('');
                $('#frmEmpresa input').attr('disabled','disabled');
            },

            success: function(response){
                var info = JSON.parse(response);
                if(info.cod = '00'){
                    $('.alertFormEmpresa').html('<p style="font-size: 12px; color:green;">'+info.msg+'</p>');
                    $('.alertFormEmpresa').slideDown();
                }else{
                    $('.alertFormEmpresa').html('<p style="font-size: 12px; color:red;">'+info.msg+'</p>');
                }
                $('.alertFormEmpresa').slideDown();
                $('#frmEmpresa input').removeAttr('disabled');
                setTimeout(function(){
                    location.reload();
                }, 2500);
            },
                
                error: function(error){
                    
                }
        });
    });

}); // END EVERYONE

function validPass(){
    var passNew = $('#txtNewPassUser').val();
    var confirmPass = $('#txtPassConfirm').val();

    if(passNew != confirmPass){
        $('.alertChangePass').html('<p style="color:red; font-size: 12px;">Las contraseñas no son iguales</p>');
        $('.alertChangePass').slideDown();
        return false;
    }

    if(passNew.length < 6){
        $('.alertChangePass').html('<p style="color:red; font-size: 12px;">La contraseña debe ser de 6 caracteres mínimo</p>');
        $('.alertChangePass').slideDown();
        return false;
    }

    $('.alertChangePass').html('');
    $('.alertChangePass').slideDown();
}

function anularFactura(){
    var nofactura = $('#no_factura').val();
    var action = 'anularFactura';

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: {action:action, nofactura:nofactura},

        success: function(response){
            if(response == 'error'){
                $('.alertNullFact').html('<p class="msg_errorModal"><b>Error al anular la factura</b></p>');
            }else{
                $('#row_'+nofactura+' .estado').html('<span class="Anulada">Anulada</span>');
                $('#form_anular_fact .btn_eliminado').remove();
                $('#row_'+nofactura+' .div_factura').html('<button type="button" class="btn_null inactive"><i class="fas fa-ban"></i></button>');
                $('.alertNullFact').html('<p class="msg_saveModal"><b>Factura anulada</b></p>');
            }
            setTimeout(function(){
                location.reload();
            }, 2600);
        },

        error: function(error){
            console.log(error);
        }
    });
}

function sedDataCategory(){

    $('.alertAddCat').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_add_cat').serialize(),
        
        success: function(response){
            if(response == 'error'){
                $('.alertAddCat').html('<p class="msg_errorModal"><b>Error al agregar la categoria</b></p>');

            }else{
                var info = JSON.parse(response);
                $('.row'+info.ID_Categoria +' .celName').html(info.Nombre_Categoria);
                $('.row'+info.ID_Categoria +' .celDesc').html(info.Descripcion);
                $('.alertAddCat').html('<p class="msg_saveModal"><b>Categoria agregada correctamente</b></p>');
            }
            setTimeout(function(){
                location.reload();
            }, 2500);
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function sedDataCat(){

    $('.alertEditCat').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_edit_cat').serialize(),
        
        success: function(response){
            if(response == 'error'){
                $('.alertEditCat').html('<p class="msg_errorModal"><b>Error al editar la categoria</b></p>');

            }else{
                var info = JSON.parse(response);
                $('.row'+info.ID_Categoria +' .celName').html(info.Nombre_Categoria);
                $('.row'+info.ID_Categoria +' .celDesc').html(info.Descripcion);
                $('.alertEditCat').html('<p class="msg_saveModal"><b>Categoria actualizada correctamente</b></p>');
            }
            setTimeout(function(){
                location.reload();
            }, 2500);
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function generarPDF(cliente,factura){

    // Variables define el alto de la ventana para mostrar
    var ancho = 1000;
    var alto = 800;
    
    // Calcular posocion x,y para centrar la ventana
    var x = parseInt((window.screen.width/2) - (ancho / 2));
    var y = parseInt((window.screen.height/2) - (alto / 2));
    
    $url = 'Package/factura/factura.php?cl='+cliente+'&f='+factura;
    // Posciones
    window.open($url,"Factura","left="+x+",top="+y+",height="+alto+",width="+ancho+",scrollbar=si,location=no,resizable=si,menubar=no");
}

function generarPDFSmall(cliente,factura){

    // Variables define el alto de la ventana para mostrar
    var ancho = 1000;
    var alto = 800;
    var tipo_factura = "";

    // Vars para validar el tipo de factura
    const typeCredit = document.querySelector('#tipo_credito');
    const typeCont = document.querySelector('#tipo_contado');

    if (typeCredit.checked) {
        tipo_factura = "Crédito"; // "credit"

    } else if (typeCont.checked) {
        tipo_factura = "Contado"; // "cont"
    }

    // Calcular posocion x,y para centrar la ventana
    var x = parseInt((window.screen.width/12) - (ancho / 12));
    var y = parseInt((window.screen.height/5) - (alto / 5));
    
    $url = 'Package/factura/factura_small.php?cl='+cliente+'&f='+factura+'&t='+tipo_factura;
    // Posciones
    window.open($url,"Factura","left="+x+",top="+y+",height="+alto+",width="+ancho+",scrollbar=si,location=no,resizable=si,menubar=no");
}

function del_product_detalle(ID_Fact_Detalle){
    
    var action = 'del_product_detalle';
    var id_detalle = ID_Fact_Detalle;

    // Ajax
    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: {action:action,id_detalle:id_detalle},
        
        success: function(response){
            if(response != '\r\nerror'){
                var info = JSON.parse(response);
                $('#detalle_venta').html(info.detalle);
                $('#detalle_totales').html(info.totales);
                
                $('#txt_cod_producto').val('');
                $('#txt_descripcion').html('-');
                $('#txt_existencia').html('-');
                $('#txt_cant_producto').val('0');
                $('#txt_precio').html('0.00');
                $('#txt_precio_total').html('0.00');

                // Bloquear cantidad
                $('#txt_cant_producto').attr('disabled','disabled');

                // Ocultar boton agregar
                $('#add_product_venta').slideUp();

            }else{
                // Detalles vacios
                $('#detalle_venta').html('');
                $('#detalle_totales').html('');
            }

            viewProcesar();
        },

        error: function(error){
            
        }

    });
}

function viewProcesar(){
    if($('#detalle_venta tr').length > 0){
        $('#btn_facturar_venta').show();

    }else{
        $('#btn_facturar_venta').hide();
    }
}

function serchForDetalle(id){
    var action = 'serchForDetalle';
    var user = id;

    // Ajax
    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: {action:action,user:user},
        
        success: function(response){
            
            if(response != '\r\nerror'){
                var info = JSON.parse(response);

                $('#detalle_venta').html(info.detalle);
                $('#detalle_totales').html(info.totales);

            }else{
                console.log("Not data");
            }

            viewProcesar();

        },

        error: function(error){
            
        }

    });
}

function getUrl(){
    var loc = window.location;
    var pathName = loc.pathname.substring(0, loc.pathname.lastIndexOf('/') + 1);
    return loc.href.substring(0, loc.href.length - ((loc.pathname + loc.search + loc.hash).length - pathName.length));
}

function sedDataProduct(){

    $('.alertAddProduct').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_add_product').serialize(),
        
        success: function(response){
            if(response == 'error'){
                $('.alertAddProduct').html('<p class="msg_errorModal"><b>Error al agregar producto</b></p>');

            }else{
                var info = JSON.parse(response);
                $('.row'+info.id_producto+' .celPrecio').html(info.nuevo_precio);
                $('.row'+info.id_producto+' .celCantidad').html(info.nueva_existencia);
                $('#txtprecio').val('');
                $('#txtcantidad').val('');
                $('.alertAddProduct').html('<p class="msg_saveModal"><b>Producto agregado correctamente</b></p>');

            }
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function sedDelProduct(){
    var pr = $('#id_producto').val();
    $('.alertDelProduct').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_del_product').serialize(),
        
        success: function(response){
            console.log(response);
            if(response == 'error'){
                $('.alertDelProduct').html('<p class="msg_errorModal"><b>Error al eliminar el producto</b></p>');

            }else{
                $('.row'+pr).remove();
                $('#form_del_product .btn_eliminado').remove();
                $('.alertDelProduct').html('<p class="msg_saveModal"><b>Producto eliminado correctamente</b></p>');
            }
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function sedDelUser(){
    var usr = $('#id_usuario').val();
    $('.alertDelUser').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_del_user').serialize(),
        
        success: function(response){
            console.log(response);
            if(response == 'error'){
                $('.alertDelUser').html('<p class="msg_errorModal"><b>Error al eliminar el usuario</b></p>');

            }else{
                $('.row'+usr).remove();
                $('#form_del_user .btn_eliminado').remove();
                $('.alertDelUser').html('<p class="msg_saveModal"><b>Usuario eliminado correctamente</b></p>');
            }
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function sedDelClient(){
    var cl = $('#id_cliente').val();
    $('.alertDelClient').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_del_client').serialize(),
        
        success: function(response){
            console.log(response);
            if(response == 'error'){
                $('.alertDelClient').html('<p class="msg_errorModal"><b>Error al eliminar el cliente</b></p>');

            }else{
                $('.row'+cl).remove();
                $('#form_del_client .btn_eliminado').remove();
                $('.alertDelClient').html('<p class="msg_saveModal"><b>Cliente eliminado correctamente</b></p>');
            }
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function sedDelSuppl(){
    var pr = $('#id_proveedor').val();
    $('.alertDelSuppl').html('');

    $.ajax({
        url: "ajax.php",
        type: "POST",
        async: true,
        data: $('#form_del_supplier').serialize(),
        
        success: function(response){
            console.log(response);
            if(response == 'error'){
                $('.alertDelSuppl').html('<p class="msg_errorModal"><b>Error al eliminar el proveedor</b></p>');

            }else{
                $('.row'+pr).remove();
                $('#form_del_supplier .btn_eliminado').remove();
                $('.alertDelSuppl').html('<p class="msg_saveModal"><b>Proveedor eliminado correctamente</b></p>');
            }
        },

        error: function(error){
            console.log(error);
        }
        
    });
}

function closeModal(){
    $('.alertAddProduct').html('');
    $('.alertAddCat').html('');
    $('#txtcantidad').val('');
    $('#txtprecio').val('');
    $('#txtNombre').val('');
    $('#txtdesc').val('')
    $('.modal').fadeOut();
}