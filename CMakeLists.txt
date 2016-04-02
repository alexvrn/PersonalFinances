cmake_minimum_required(VERSION 2.8) # Проверка версии CMake.
                                    # Если версия установленой программы
                                    # старее указаной, произойдёт аварийный выход.

PROJECT(PersonalFinances)

SET(CMAKE_PREFIX_PATH "C:\\Qt\\5.6\\mingw49_32\\lib\\cmake")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

FIND_PACKAGE(Qt5Widgets)

SET(HEADERS
    src/DBWorker.h
    src/DBController.h
    src/DensityController.h
    src/FinancesController.h)

SET(SOURCES
    src/main.cpp
    src/DBWorker.cpp
    src/DBController.cpp
    src/DensityController.cpp
    src/FinancesController.cpp)

SET(RESOURCE
    src/qml/qml.qrc
    src/qml/material-qml/material.qrc
    src/qml/picker/picker.qrc
)

qt5_add_resources(RESOURCE ${RESOURCE})

INCLUDE_DIRECTORIES(src/qml/icons)
INCLUDE_DIRECTORIES(src/qml/picker)
INCLUDE_DIRECTORIES(src/qml/picker/Global)
INCLUDE_DIRECTORIES(src/qml/picker/Other)
INCLUDE_DIRECTORIES(src/qml/material-qml)
INCLUDE_DIRECTORIES(src/qml)
INCLUDE_DIRECTORIES(src)

ADD_EXECUTABLE(PersonalFinances ${HEADERS} ${SOURCES} ${RESOURCE}) # Создает исполняемый файл с именем PersonalFinances

QT5_USE_MODULES(PersonalFinances Widgets Sql Qml Quick)
