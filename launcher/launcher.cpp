#include "launcher.h"
#include <qprocess.h>
#include "ui_launcher.h"

#include <iostream>

Launcher::Launcher(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::Launcher)
{
    ui->setupUi(this);

    ui->txt_ip->setText("192.168.0.7");

    ui->combo_personaje->addItem("Aegis",1);
    ui->combo_personaje->addItem("Solange",2);

    ui->combo_mapa->addItem("Acuaris","demo");

    ui->group_socket->setVisible(false);
}

Launcher::~Launcher()
{
    delete ui;
}

void Launcher::on_btn_iniciar_clicked()
{
    usuario usu = usuario();

    int personaje = ui->combo_personaje->itemData(ui->combo_personaje->currentIndex()).toInt();
    QString mapa = ui->combo_mapa->itemData(ui->combo_mapa->currentIndex()).toString();
    QString ip = ui->txt_ip->text();
    QString nombre = ui->txt_nombre->text();
    QString puerto = ui->txt_puerto->text();


    if(ui->radioButton->isChecked())
    {
        //servidor
        usu.nuevo_servidor(personaje,mapa,nombre,ip,puerto);
    }
    else
    {
        //cliente
        usu.nuevo_cliente(personaje,nombre,ip,puerto);
    }

    crear_file(usu);
    abrir_exe();

}

void Launcher::on_radioButton_clicked()
{
    ui->group_mapas->setVisible(true);
    ui->txt_ip->setDisabled(true);
}

void Launcher::on_radioButton_2_clicked()
{
    ui->group_mapas->setVisible(false);
    ui->txt_ip->setDisabled(false);
}

void Launcher::abrir_exe()
{
    QProcess process;
    process.start("D:/Programas/Love/love.exe D:/Proyectos/Last_Eclipse/beta_3");
    process.waitForFinished(-1);
}

void Launcher::crear_file(usuario usu)
{
    QString fileName = "C:/Users/Adrian/AppData/Roaming/LOVE/Last_Eclipse/Game_data.lua";
    QFile file(fileName);
    bool openOk = file.open(QFile::WriteOnly|QFile::Truncate);

    if(openOk)
    {
        QTextStream out(&file);
        out << usu.lua_conf();

       file.close();
    }
}

void Launcher::borrar_file()
{

}

void Launcher::on_checkBox_stateChanged(int arg1)
{
    if(arg1==2)
    {
       ui->group_socket->setVisible(true);
    }
    else
    {
        ui->group_socket->setVisible(false);
    }
}
