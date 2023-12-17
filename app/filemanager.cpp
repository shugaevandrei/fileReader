#include <QDir>
#include <QBuffer>
#include <QTextStream>

#include "filemanager.h"
#include "notification.h"

FileManager::FileManager(QObject *parent)
    : QObject(parent), buffFile_(std::make_unique<QBuffer>())
{}

FileManager::~FileManager()
{}

void FileManager::setFile(const QString &path)
{
    path_ = path;

    QFile file(path);
    if (file.exists()) {
        if (!file.open(QIODevice::ReadWrite | QIODevice::Text))
            _setBuffFile(errorOpenFile);
        else {
            _setBuffFile(file.readAll());
            file.close();
        }
    }
    else
        _setBuffFile(fileNotExist);
}

void FileManager::removeFile(const QString &path, bool isDir)
{
    if (isDir) {
        QDir dir(path);
        if (dir.exists())
            dir.removeRecursively();
        else
            _setBuffFile(dirNotExist);
    }
    else  {
        if (QFile(path).exists())
            QFile::remove(path);
        else
            _setBuffFile(fileNotExist);
    }
}

bool FileManager::copyFile(const QString &path, const QString &newPath)
{
    if (QFile(path).exists())
        return QFile::copy(path, newPath);
    else {
        _setBuffFile(fileNotExist);
        return 0;
    }
}

bool FileManager::removeText(int startSeek, int finishSeek)
{
    QFile file(path_);
    if (!file.open(QIODevice::ReadWrite | QIODevice::Text))
        _setBuffFile(errorOpenFile);
    else {
        QByteArray currentText = buffFile_->data();
        currentText.remove(startSeek, finishSeek - startSeek);
        file.resize(0);
        QTextStream outStream(&file);
        outStream <<currentText;
        _setBuffFile(currentText);
        file.close();
    }
}

bool FileManager::copyText(const QString &txt)
{
    buffText_ = txt;
}

bool FileManager::pasteText(int seek)
{
    QFile file(path_);
    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        buffFile_->setData(errorOpenFile);
        emit textChanged();
    }
    else {
        QByteArray currentText = buffFile_->data();
        currentText.insert(seek, buffText_);
        file.resize(0);
        QTextStream outStream(&file);
        outStream <<currentText;
        _setBuffFile(currentText);
        file.close();
    }
}

QString FileManager::_text()
{
    return QString(buffFile_->data());
}

void FileManager::_setBuffFile(const QByteArray &array)
{
    buffFile_->setData(array);
    emit textChanged();
}
