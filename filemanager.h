#pragma once

#include <QObject>
#include <QFile>

class FileManager : public QObject
{
    Q_OBJECT
public:
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE QString setPath(const QString &path);
    Q_INVOKABLE void remove(const QString &path);
    Q_INVOKABLE void copy(const QString &path, const QString &newPath);

    QFile file;
    QString path;

signals:

};
