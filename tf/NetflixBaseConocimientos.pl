/*
*/
 :- use_module(library(pce)).
 :- pce_image_directory('./src').
 :- use_module(library(pce_style_item)).
 :- dynamic color/7.

 :- initialization rlc_color(window, 0,255,0).


abrir_conexion:-
    odbc_connect('Netflix',_,
                 [user('root'),
                 password(''),
                 alias(netflix),
                 open(once)]).

close_connection:-
	odbc_disconnect('netflix').


/*Obtener todos los ids de las peliculas en un arreglo*/
get_peliculas_id(A):-
 findall(A,
                odbc_query('netflix',
                           'select (IdMovies) from Titles',
                           row(A)),
                A).

/*obtener todos los nombres de las peliculas en un arreglo*/
get_peliculas_name(A):-
 findall(A,
                odbc_query('netflix',
                           'select (Titles) from Titles',
                           row(A)),
                A).

/*Obtener todas las peliculas que el al usuario le gustaron*/
get_movie_user(A):-
 findall(A,
                odbc_query('netflix',
                           'select (IdMovie) from Consultar',
                           row(A)),
                A).


/*obtner todos los usuarios que vieron una pelicula en un arreglo*/
get_user_hist(A):-
 findall(A,
                odbc_query('netflix',
                           'select (IdUser) from User_Hist
			   WHERE IdMovie in (select * from Consultar) ',
                           row(A)),
                A).

get_recomendadas(A):-
	 findall(A,
                odbc_query('netflix',
                           "select (Titles) from Titles
			   WHERE IdMovie in () "-[get_movie_user(A)],
                           row(A)),
                A).



consultar_peliculas(F):-
    odbc_query('netflix','SELECT * FROM Titles',F).

consultar_recomendadas(F):-
     odbc_query('netflix','EXEC SP_Peliculas_Recomendadas',F).

limpiar_gustos(F):-
    odbc_query('netflix','TRUNCATE TABLE Consultar',F).


insertar_pelicula(F,A):-
    odbc_query('netflix',"INSERT INTO Consultar (IdMovie) VALUES ('~w')"-[A],affected(F)).

buscar_pelicula_by_id(F,A):-
     odbc_query('netflix',
                "SELECT *
                FROM Titles AS A
                WHERE A.IdMovie = '~w'"-[A],F).

buscar_pelicula_by_name(F,A):-
     odbc_query('netflix',
                "SELECT *
                FROM Titles AS A
                WHERE A.Titles LIKE '%~w%' "-[A],F).


resource(portada, image, image('portada.jpg')).



mostrar_imagen(Pantalla, Imagen) :- new(Figura, figure),
                                     new(Bitmap, bitmap(resource(Imagen),@on)),
                                     send(Bitmap, name, 1),
                                     send(Figura, display, Bitmap),
                                     send(Figura, status, 1),
                                     send(Pantalla, display,Figura,point(0,0)).


crea_interfaz_inicio:-
   new(@interfaz,window('Sistema Experto Netflix',size(900,900))),
   mostrar_imagen(@interfaz, portada),
   send(@interfaz,open_centered).


preguntar(Preg,Resp):-new(Di,dialog('Colsultar Datos:')),
                        new(L2,label(texto,'Responde las siguientes preguntas')),
                        id_imagen_preg(Preg,Imagen),
                        imagen_pregunta(Di,Imagen),
                        new(La,label(prob,Preg)),
                        new(B1,button(si,and(message(Di,return,si)))),
                        new(B2,button(no,and(message(Di,return,no)))),
                        send(Di, gap, size(25,25)),
                        send(Di,append(L2)),
                        send(Di,append(La)),
                        send(Di,append(B1)),
                        send(Di,append(B2)),
                        send(Di,default_button,'si'),
                        send(Di,open_centered),get(Di,confirm,Answer),
                        free(Di),
                        Resp=Answer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  interfaz_principal:-new(@main,dialog('Sistema Experto Diagnosticador de Enfermedades deL Goldfish',
        size(1000,1000))),
        new(@texto, label(nombre,'El Diagnostico a partir de los datos es:',font('times','roman',18))),
        new(@resp1, label(nombre,'',font('times','roman',22))),
        new(@lblExp1, label(nombre,'',font('times','roman',14))),
        new(@lblExp2, label(nombre,'',font('times','roman',14))),
        new(@salir,button('SALIR',and(message(@main,destroy),message(@main,free)))),
        new(@boton, button('Iniciar consulta',message(@prolog, botones))),

        new(@btntratamiento,button('¿Tratamiento?')),

        nueva_imagen(@main, img_principal),
        send(@main, display,@boton,point(138,450)),
        send(@main, display,@texto,point(20,130)),
        send(@main, display,@salir,point(300,450)),
        send(@main, display,@resp1,point(20,180)),
        send(@main,open_centered).

       borrado:- send(@resp1, selection('')).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  crea_interfaz_inicio:- new(@interfaz,dialog('Bienvenido al Sistema Experto Diagnosticador',
  size(1000,1000))),

  mostrar_imagen(@interfaz, portada),

  new(BotonComenzar,button('COMENZAR',and(message(@prolog,interfaz_principal) ,
  and(message(@interfaz,destroy),message(@interfaz,free)) ))),
  new(BotonSalir,button('SALIDA',and(message(@interfaz,destroy),message(@interfaz,free)))),
  send(@interfaz,append(BotonComenzar)),
  send(@interfaz,append(BotonSalir)),
  send(@interfaz,open_centered).


