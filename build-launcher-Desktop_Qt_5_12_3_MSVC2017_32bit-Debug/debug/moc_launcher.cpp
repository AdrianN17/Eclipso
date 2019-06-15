/****************************************************************************
** Meta object code from reading C++ file 'launcher.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.3)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../launcher/launcher.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'launcher.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.3. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Launcher_t {
    QByteArrayData data[13];
    char stringdata0[189];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Launcher_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Launcher_t qt_meta_stringdata_Launcher = {
    {
QT_MOC_LITERAL(0, 0, 8), // "Launcher"
QT_MOC_LITERAL(1, 9, 22), // "on_btn_iniciar_clicked"
QT_MOC_LITERAL(2, 32, 0), // ""
QT_MOC_LITERAL(3, 33, 22), // "on_radioButton_clicked"
QT_MOC_LITERAL(4, 56, 24), // "on_radioButton_2_clicked"
QT_MOC_LITERAL(5, 81, 9), // "abrir_exe"
QT_MOC_LITERAL(6, 91, 10), // "crear_file"
QT_MOC_LITERAL(7, 102, 7), // "usuario"
QT_MOC_LITERAL(8, 110, 3), // "usu"
QT_MOC_LITERAL(9, 114, 24), // "on_checkBox_stateChanged"
QT_MOC_LITERAL(10, 139, 4), // "arg1"
QT_MOC_LITERAL(11, 144, 38), // "on_combo_personaje_currentInd..."
QT_MOC_LITERAL(12, 183, 5) // "index"

    },
    "Launcher\0on_btn_iniciar_clicked\0\0"
    "on_radioButton_clicked\0on_radioButton_2_clicked\0"
    "abrir_exe\0crear_file\0usuario\0usu\0"
    "on_checkBox_stateChanged\0arg1\0"
    "on_combo_personaje_currentIndexChanged\0"
    "index"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Launcher[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       7,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   49,    2, 0x08 /* Private */,
       3,    0,   50,    2, 0x08 /* Private */,
       4,    0,   51,    2, 0x08 /* Private */,
       5,    0,   52,    2, 0x08 /* Private */,
       6,    1,   53,    2, 0x08 /* Private */,
       9,    1,   56,    2, 0x08 /* Private */,
      11,    1,   59,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 7,    8,
    QMetaType::Void, QMetaType::Int,   10,
    QMetaType::Void, QMetaType::Int,   12,

       0        // eod
};

void Launcher::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<Launcher *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->on_btn_iniciar_clicked(); break;
        case 1: _t->on_radioButton_clicked(); break;
        case 2: _t->on_radioButton_2_clicked(); break;
        case 3: _t->abrir_exe(); break;
        case 4: _t->crear_file((*reinterpret_cast< usuario(*)>(_a[1]))); break;
        case 5: _t->on_checkBox_stateChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 6: _t->on_combo_personaje_currentIndexChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Launcher::staticMetaObject = { {
    &QMainWindow::staticMetaObject,
    qt_meta_stringdata_Launcher.data,
    qt_meta_data_Launcher,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *Launcher::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Launcher::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Launcher.stringdata0))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int Launcher::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 7;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
