/********************************************************************************
** Form generated from reading UI file 'launcher.ui'
**
** Created by: Qt User Interface Compiler version 5.12.3
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_LAUNCHER_H
#define UI_LAUNCHER_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QGroupBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QLineEdit>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QRadioButton>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_Launcher
{
public:
    QWidget *centralWidget;
    QPushButton *btn_iniciar;
    QGroupBox *groupBox;
    QRadioButton *radioButton_2;
    QRadioButton *radioButton;
    QLabel *label_2;
    QLineEdit *txt_nombre;
    QCheckBox *checkBox;
    QLabel *label_4;
    QSpinBox *spin_cantidad;
    QLabel *label_5;
    QSpinBox *spin_can_enemigos;
    QGroupBox *group_personajes;
    QLabel *lb_img1;
    QLabel *lb_personaje;
    QComboBox *combo_personaje;
    QGroupBox *group_mapas;
    QLabel *lb_img2;
    QLabel *lb_mapa_detalles;
    QComboBox *combo_mapa;
    QGroupBox *group_ip;
    QLabel *label;
    QLineEdit *txt_ip;
    QGroupBox *group_socket;
    QLabel *label_3;
    QLineEdit *txt_puerto;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *Launcher)
    {
        if (Launcher->objectName().isEmpty())
            Launcher->setObjectName(QString::fromUtf8("Launcher"));
        Launcher->resize(600, 700);
        Launcher->setMinimumSize(QSize(600, 700));
        Launcher->setMaximumSize(QSize(600, 700));
        centralWidget = new QWidget(Launcher);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        btn_iniciar = new QPushButton(centralWidget);
        btn_iniciar->setObjectName(QString::fromUtf8("btn_iniciar"));
        btn_iniciar->setGeometry(QRect(260, 610, 93, 28));
        groupBox = new QGroupBox(centralWidget);
        groupBox->setObjectName(QString::fromUtf8("groupBox"));
        groupBox->setGeometry(QRect(40, 20, 321, 221));
        QFont font;
        font.setBold(true);
        font.setWeight(75);
        groupBox->setFont(font);
        radioButton_2 = new QRadioButton(groupBox);
        radioButton_2->setObjectName(QString::fromUtf8("radioButton_2"));
        radioButton_2->setGeometry(QRect(150, 40, 101, 20));
        QFont font1;
        font1.setBold(false);
        font1.setWeight(50);
        radioButton_2->setFont(font1);
        radioButton = new QRadioButton(groupBox);
        radioButton->setObjectName(QString::fromUtf8("radioButton"));
        radioButton->setGeometry(QRect(20, 40, 111, 20));
        radioButton->setFont(font1);
        radioButton->setChecked(true);
        label_2 = new QLabel(groupBox);
        label_2->setObjectName(QString::fromUtf8("label_2"));
        label_2->setGeometry(QRect(40, 80, 55, 16));
        label_2->setFont(font1);
        txt_nombre = new QLineEdit(groupBox);
        txt_nombre->setObjectName(QString::fromUtf8("txt_nombre"));
        txt_nombre->setGeometry(QRect(120, 80, 113, 22));
        txt_nombre->setFont(font1);
        checkBox = new QCheckBox(groupBox);
        checkBox->setObjectName(QString::fromUtf8("checkBox"));
        checkBox->setGeometry(QRect(50, 190, 191, 20));
        checkBox->setFont(font1);
        label_4 = new QLabel(groupBox);
        label_4->setObjectName(QString::fromUtf8("label_4"));
        label_4->setGeometry(QRect(20, 120, 81, 16));
        label_4->setFont(font1);
        spin_cantidad = new QSpinBox(groupBox);
        spin_cantidad->setObjectName(QString::fromUtf8("spin_cantidad"));
        spin_cantidad->setGeometry(QRect(140, 120, 51, 22));
        spin_cantidad->setFont(font1);
        label_5 = new QLabel(groupBox);
        label_5->setObjectName(QString::fromUtf8("label_5"));
        label_5->setGeometry(QRect(10, 160, 101, 16));
        label_5->setFont(font1);
        spin_can_enemigos = new QSpinBox(groupBox);
        spin_can_enemigos->setObjectName(QString::fromUtf8("spin_can_enemigos"));
        spin_can_enemigos->setGeometry(QRect(140, 160, 42, 22));
        spin_can_enemigos->setFont(font1);
        group_personajes = new QGroupBox(centralWidget);
        group_personajes->setObjectName(QString::fromUtf8("group_personajes"));
        group_personajes->setGeometry(QRect(40, 250, 521, 171));
        group_personajes->setFont(font);
        lb_img1 = new QLabel(group_personajes);
        lb_img1->setObjectName(QString::fromUtf8("lb_img1"));
        lb_img1->setGeometry(QRect(20, 30, 241, 91));
        lb_img1->setFont(font1);
        lb_personaje = new QLabel(group_personajes);
        lb_personaje->setObjectName(QString::fromUtf8("lb_personaje"));
        lb_personaje->setGeometry(QRect(30, 119, 391, 41));
        lb_personaje->setFont(font1);
        combo_personaje = new QComboBox(group_personajes);
        combo_personaje->setObjectName(QString::fromUtf8("combo_personaje"));
        combo_personaje->setGeometry(QRect(302, 60, 120, 22));
        combo_personaje->setFont(font1);
        group_mapas = new QGroupBox(centralWidget);
        group_mapas->setObjectName(QString::fromUtf8("group_mapas"));
        group_mapas->setGeometry(QRect(40, 430, 521, 171));
        group_mapas->setFont(font);
        lb_img2 = new QLabel(group_mapas);
        lb_img2->setObjectName(QString::fromUtf8("lb_img2"));
        lb_img2->setGeometry(QRect(200, 30, 241, 91));
        lb_img2->setFont(font1);
        lb_mapa_detalles = new QLabel(group_mapas);
        lb_mapa_detalles->setObjectName(QString::fromUtf8("lb_mapa_detalles"));
        lb_mapa_detalles->setGeometry(QRect(40, 129, 391, 31));
        lb_mapa_detalles->setFont(font1);
        combo_mapa = new QComboBox(group_mapas);
        combo_mapa->setObjectName(QString::fromUtf8("combo_mapa"));
        combo_mapa->setGeometry(QRect(30, 70, 120, 22));
        combo_mapa->setFont(font1);
        group_ip = new QGroupBox(centralWidget);
        group_ip->setObjectName(QString::fromUtf8("group_ip"));
        group_ip->setGeometry(QRect(370, 20, 191, 91));
        group_ip->setFont(font);
        label = new QLabel(group_ip);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(20, 40, 31, 16));
        label->setFont(font1);
        txt_ip = new QLineEdit(group_ip);
        txt_ip->setObjectName(QString::fromUtf8("txt_ip"));
        txt_ip->setEnabled(false);
        txt_ip->setGeometry(QRect(60, 40, 121, 22));
        txt_ip->setFont(font1);
        group_socket = new QGroupBox(centralWidget);
        group_socket->setObjectName(QString::fromUtf8("group_socket"));
        group_socket->setEnabled(true);
        group_socket->setGeometry(QRect(370, 160, 191, 81));
        group_socket->setFont(font);
        label_3 = new QLabel(group_socket);
        label_3->setObjectName(QString::fromUtf8("label_3"));
        label_3->setGeometry(QRect(10, 30, 55, 16));
        label_3->setFont(font1);
        txt_puerto = new QLineEdit(group_socket);
        txt_puerto->setObjectName(QString::fromUtf8("txt_puerto"));
        txt_puerto->setEnabled(false);
        txt_puerto->setGeometry(QRect(70, 30, 113, 22));
        txt_puerto->setFont(font1);
        Launcher->setCentralWidget(centralWidget);
        statusBar = new QStatusBar(Launcher);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        Launcher->setStatusBar(statusBar);

        retranslateUi(Launcher);

        QMetaObject::connectSlotsByName(Launcher);
    } // setupUi

    void retranslateUi(QMainWindow *Launcher)
    {
        Launcher->setWindowTitle(QApplication::translate("Launcher", "Last Eclipse-Launcher", nullptr));
        btn_iniciar->setText(QApplication::translate("Launcher", "Iniciar", nullptr));
        groupBox->setTitle(QApplication::translate("Launcher", "Configuracion de usuario", nullptr));
        radioButton_2->setText(QApplication::translate("Launcher", "Jugar Cliente", nullptr));
        radioButton->setText(QApplication::translate("Launcher", "Jugar Servidor", nullptr));
        label_2->setText(QApplication::translate("Launcher", "Nombre :", nullptr));
        checkBox->setText(QApplication::translate("Launcher", "Habilitar opciones avanzadas", nullptr));
        label_4->setText(QApplication::translate("Launcher", "Max players :", nullptr));
        label_5->setText(QApplication::translate("Launcher", "Max enemigos :", nullptr));
        group_personajes->setTitle(QApplication::translate("Launcher", "Personajes", nullptr));
        lb_img1->setText(QString());
        lb_personaje->setText(QApplication::translate("Launcher", "Armas : ", nullptr));
        group_mapas->setTitle(QApplication::translate("Launcher", "Mapas", nullptr));
        lb_img2->setText(QString());
        lb_mapa_detalles->setText(QApplication::translate("Launcher", "Detalles :", nullptr));
        group_ip->setTitle(QApplication::translate("Launcher", "Direccion ", nullptr));
        label->setText(QApplication::translate("Launcher", "IP :", nullptr));
        group_socket->setTitle(QApplication::translate("Launcher", "Socket", nullptr));
        label_3->setText(QApplication::translate("Launcher", "Puerto :", nullptr));
        txt_puerto->setText(QApplication::translate("Launcher", "22122", nullptr));
    } // retranslateUi

};

namespace Ui {
    class Launcher: public Ui_Launcher {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_LAUNCHER_H
