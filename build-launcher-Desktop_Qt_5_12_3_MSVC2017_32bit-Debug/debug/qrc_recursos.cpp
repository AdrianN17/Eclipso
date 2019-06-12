/****************************************************************************
** Resource object code
**
** Created by: The Resource Compiler for Qt version 5.12.3
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

static const unsigned char qt_resource_data[] = {
  // D:/Proyectos/Last_Eclipse/launcher/diseño.css
  0x0,0x0,0x0,0x1a,
  0x51,
  0x4c,0x69,0x6e,0x65,0x45,0x64,0x69,0x74,0x20,0x7b,0x20,0x63,0x6f,0x6c,0x6f,0x72,
  0x3a,0x20,0x72,0x65,0x64,0x20,0x7d,0xd,0xa,
  
};

static const unsigned char qt_resource_name[] = {
  // css
  0x0,0x3,
  0x0,0x0,0x6a,0xa3,
  0x0,0x63,
  0x0,0x73,0x0,0x73,
    // diseño.css
  0x0,0xa,
  0x4,0x8f,0x2b,0xe3,
  0x0,0x64,
  0x0,0x69,0x0,0x73,0x0,0x65,0x0,0xf1,0x0,0x6f,0x0,0x2e,0x0,0x63,0x0,0x73,0x0,0x73,
  
};

static const unsigned char qt_resource_struct[] = {
  // :
  0x0,0x0,0x0,0x0,0x0,0x2,0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x1,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
  // :/css
  0x0,0x0,0x0,0x0,0x0,0x2,0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x2,
0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,
  // :/css/diseño.css
  0x0,0x0,0x0,0xc,0x0,0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x0,
0x0,0x0,0x1,0x6b,0x4e,0xd,0x66,0xac,

};

#ifdef QT_NAMESPACE
#  define QT_RCC_PREPEND_NAMESPACE(name) ::QT_NAMESPACE::name
#  define QT_RCC_MANGLE_NAMESPACE0(x) x
#  define QT_RCC_MANGLE_NAMESPACE1(a, b) a##_##b
#  define QT_RCC_MANGLE_NAMESPACE2(a, b) QT_RCC_MANGLE_NAMESPACE1(a,b)
#  define QT_RCC_MANGLE_NAMESPACE(name) QT_RCC_MANGLE_NAMESPACE2( \
        QT_RCC_MANGLE_NAMESPACE0(name), QT_RCC_MANGLE_NAMESPACE0(QT_NAMESPACE))
#else
#   define QT_RCC_PREPEND_NAMESPACE(name) name
#   define QT_RCC_MANGLE_NAMESPACE(name) name
#endif

#ifdef QT_NAMESPACE
namespace QT_NAMESPACE {
#endif

bool qRegisterResourceData(int, const unsigned char *, const unsigned char *, const unsigned char *);

bool qUnregisterResourceData(int, const unsigned char *, const unsigned char *, const unsigned char *);

#ifdef QT_NAMESPACE
}
#endif

int QT_RCC_MANGLE_NAMESPACE(qInitResources_recursos)();
int QT_RCC_MANGLE_NAMESPACE(qInitResources_recursos)()
{
    QT_RCC_PREPEND_NAMESPACE(qRegisterResourceData)
        (0x2, qt_resource_struct, qt_resource_name, qt_resource_data);
    return 1;
}

int QT_RCC_MANGLE_NAMESPACE(qCleanupResources_recursos)();
int QT_RCC_MANGLE_NAMESPACE(qCleanupResources_recursos)()
{
    QT_RCC_PREPEND_NAMESPACE(qUnregisterResourceData)
       (0x2, qt_resource_struct, qt_resource_name, qt_resource_data);
    return 1;
}

namespace {
   struct initializer {
       initializer() { QT_RCC_MANGLE_NAMESPACE(qInitResources_recursos)(); }
       ~initializer() { QT_RCC_MANGLE_NAMESPACE(qCleanupResources_recursos)(); }
   } dummy;
}
