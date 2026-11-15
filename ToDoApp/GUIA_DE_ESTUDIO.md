# No editar este archivo

Esta guía está **duplicada** en la raíz del proyecto:

    ../GUIA_DE_ESTUDIO.md

La copia buena es la de la raíz. Este archivo está dentro de la carpeta del
target (`ToDoApp/`), que Xcode sincroniza como grupo de archivos, así que un
`.md` aquí terminaría empaquetado como recurso del bundle sin aportar nada.

Se deja este aviso en lugar de borrar el archivo porque el shell del entorno
está bloqueado por un problema de permisos de Windows y no se pudo mover.
Cuando puedas, bórralo:

    rm "ToDoApp/GUIA_DE_ESTUDIO.md"
