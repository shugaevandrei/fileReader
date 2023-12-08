#include <QDebug>
#include "filemanager.h"

FileManager::FileManager(QObject *parent)
    : QObject{parent}
{

}

QString FileManager::setPath(const QString &path)
{
    this->path = path;

    QFile file(path);
    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        qDebug()<< "нельзя открыть";
    }
    return QString(file.readAll());
    //file.write(msg, qstrlen(msg));        // write to stderr
    file.close();
}

void FileManager::remove(const QString &path)
{
    qDebug() << "удалил ?" <<path << QFile::remove(path);
}

void FileManager::copy(const QString &path, const QString &newPath)
{
//    if (path == newPath)
//        newPath + "1";
    qDebug() << "скопировался ?" <<path <<newPath << QFile::copy(path, newPath);
}
