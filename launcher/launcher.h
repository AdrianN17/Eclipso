#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QMainWindow>
#include <QFile>
#include <QTextStream>
#include <QDataStream>
#include <QTcpSocket>
#include <QHostAddress>


#include "usuario.h"

namespace Ui {
class Launcher;
}

class Launcher : public QMainWindow
{
    Q_OBJECT

public:
    explicit Launcher(QWidget *parent = nullptr);
    ~Launcher();


private slots:
    void on_btn_iniciar_clicked();

    void on_radioButton_clicked();

    void on_radioButton_2_clicked();

    //funciones principales

    void abrir_exe();
    void crear_file(usuario usu);
    void borrar_file();

    void on_checkBox_stateChanged(int arg1);

private:
    Ui::Launcher *ui;

};

#endif // LAUNCHER_H
