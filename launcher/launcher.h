#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QMainWindow>
#include <QFile>
#include <QTextStream>
#include <QDataStream>
#include <QTcpSocket>
#include <QHostAddress>
#include <QDir>


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
    QString ip_guardada="0.0.0.0";

    QList<QImage> personaje_lista;
    QList<QImage> mapa_lista;


private slots:
    void on_btn_iniciar_clicked();

    void on_radioButton_clicked();

    void on_radioButton_2_clicked();

    //funciones principales

    void abrir_exe(usuario usu);

    void on_checkBox_stateChanged(int arg1);

    void on_combo_personaje_currentIndexChanged(int index);

private:
    Ui::Launcher *ui;


};

#endif // LAUNCHER_H
