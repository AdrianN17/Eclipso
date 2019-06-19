#include "launcher.h"
#include <qprocess.h>
#include "ui_launcher.h"

Launcher::Launcher(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::Launcher)
{
    ui->setupUi(this);

    ui->combo_personaje->addItem("Aegis",1);
    ui->combo_personaje->addItem("Solange",2);

    ui->spin_cantidad->setRange(1,8);

    ui->spin_can_enemigos->setRange(0,100);
    ui->spin_can_enemigos->setValue(25);

    ui->combo_mapa->addItem("Acuaris","demo");

    QTcpSocket socket;
    socket.connectToHost("8.8.8.8", 53);
    if (socket.waitForConnected()) {
       ui->txt_ip->setText(socket.localAddress().toString());
       ip_guardada=socket.localAddress().toString();
    }
    else {
        ui->txt_ip->setText("0.0.0.0");
    }

    QString IpRange = "(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])";
    QRegularExpression IpRegex ("^" + IpRange
                                   + "(\\." + IpRange + ")"
                                   + "(\\." + IpRange + ")"
                                   + "(\\." + IpRange + ")$");
    QRegularExpressionValidator *ipValidator = new QRegularExpressionValidator(IpRegex, this);
    ui->txt_ip->setValidator(ipValidator);


    ui->txt_puerto->setValidator( new QIntValidator(0, 99999, this) );

    QFile stylesheet_file(":/css/diseño.css");
    stylesheet_file.open(QFile::ReadOnly);
    QString stylesheet = QLatin1String(stylesheet_file.readAll());
    this->setStyleSheet(stylesheet);
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
    int cantidad = ui->spin_cantidad->value();
    int cantidad_enemigos= ui->spin_can_enemigos->value();

    if(nombre.isEmpty())
    {
        nombre="player";
    }

    if(ui->radioButton->isChecked())
    {
        //servidor
        usu.nuevo_servidor(personaje,mapa,nombre,ip,puerto,cantidad,cantidad_enemigos);
    }
    else
    {
        //cliente
        usu.nuevo_cliente(personaje,nombre,ip,puerto);
    }

    abrir_exe(usu);


}

void Launcher::on_radioButton_clicked()
{
    ui->group_mapas->setVisible(true);
    ui->txt_ip->setDisabled(true);
    ui->txt_ip->setText(ip_guardada);

    ui->spin_cantidad->setDisabled(false);
    ui->spin_can_enemigos->setDisabled(false);
}

void Launcher::on_radioButton_2_clicked()
{
    ui->group_mapas->setVisible(false);
    ui->txt_ip->setDisabled(false);

    ui->spin_cantidad->setDisabled(true);
    ui->spin_can_enemigos->setDisabled(true);
}

void Launcher::abrir_exe(usuario usu)
{
    QProcess process;
   // QString comand="D:/Programas/Love/love.exe D:/Proyectos/Eclipso/beta_3 ";

    QString dir = QCoreApplication::applicationDirPath();

    qDebug()<<dir;


    //QString comand="D:/Proyectos/Eclipso/launcher/exe/Eclipso.exe";
    QString comand = QString("%1%2").arg(dir).arg("/exe/Eclipso.exe");
    qDebug()<<comand;

    QString table = usu.lua_conf().toUtf8().toBase64();
    QString query = QString("%1  %2").arg(comand).arg(table);
    process.startDetached(query);
    process.close();
}

void Launcher::on_checkBox_stateChanged(int arg1)
{
    if(arg1==2)
    {
       ui->txt_puerto->setDisabled(false);
    }
    else
    {
        ui->txt_puerto->setDisabled(true);
    }
}

void Launcher::on_combo_personaje_currentIndexChanged(int index)
{
    //qDebug()<<index;

    //podria llamarse eclipso
}
