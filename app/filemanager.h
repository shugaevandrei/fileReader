#pragma once

#include <QObject>
#include <memory>

class QBuffer;

class FileManager : public QObject
{
    Q_OBJECT

public:
    explicit FileManager(QObject *parent = nullptr);
    virtual ~FileManager();

    Q_PROPERTY(QString text READ _text NOTIFY textChanged)

    Q_INVOKABLE void setFile(const QString &path);
    Q_INVOKABLE void removeFile(const QString &path, bool isDir);
    Q_INVOKABLE bool copyFile(const QString &path, const QString &newPath);

    Q_INVOKABLE bool removeText(int startSeek, int finishSeek);
    Q_INVOKABLE bool copyText(const QString &txt);
    Q_INVOKABLE bool pasteText(int seek);

signals:
    void textChanged();

private:
    QString path_ = "";
    QString buffText_ = "";
    std::unique_ptr<QBuffer> buffFile_;

    QString _text();
    void _setBuffFile(const QByteArray &array);
};
