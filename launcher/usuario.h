#ifndef USUARIO_H
#define USUARIO_H

#include <QString>

class usuario
{
public:
    usuario();
    void nuevo_servidor(int personaje,QString mapa,QString nombre,QString ip,QString puerto,int cantidad);
    void nuevo_cliente(int personaje, QString nombre,QString ip,QString puerto);

    QString lua_conf();

private:
    int personaje;
    QString mapa;
    QString nombre;
    QString ip;
    QString puerto;
    int tipo;
    int cantidad;
};


#endif // USUARIO_H
