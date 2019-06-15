#include "usuario.h"

usuario::usuario()
{

}

void usuario::nuevo_servidor(int personaje,QString mapa,QString nombre,QString ip,QString puerto,int cantidad)
{
    this->personaje=personaje;
    this->mapa=mapa;
    this->nombre=nombre;
    this->ip=ip;
    this->puerto=puerto;
    this->cantidad=cantidad;

    this->tipo=1;
}

void usuario::nuevo_cliente(int personaje, QString nombre,QString ip,QString puerto)
{
    this->personaje=personaje;
    this->nombre=nombre;
    this->ip=ip;
    this->puerto=puerto;

    this->tipo=0;
}

QString usuario::lua_conf()
{
    QString data;

    if(this->tipo==1)
    {
       QString server_data="return {personaje = %1, mapa = '%2' , nombre = '%3', ip = '%4', puerto = '%5', tipo = '%6', cantidad = '%7'}";
       data = QString(server_data).arg(this->personaje).arg(this->mapa).arg(this->nombre).arg(this->ip).arg(this->puerto).arg("server").arg(this->cantidad);

    }
    else
    {
        QString client_data="return {personaje = %1, nombre = '%2', ip = '%3', puerto = '%4' , tipo = '%5'}";
        data = QString(client_data).arg(this->personaje).arg(this->nombre).arg(this->ip).arg(this->puerto).arg("client");
    }

    return data;
}

