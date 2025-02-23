echo "開始關閉服務"
docker-compose down
echo "關閉服務任務完成"
docker version
docker info
docker-compose version
docker-compose build
docker-compose up -d
rm -r .\python\result\
# 设置请求的URL
$url = "http://localhost:4000/api"

# 设置最大重试次数
$maxRetryAttempts = 5

# 循环尝试
for ($attempt = 1; $attempt -le $maxRetryAttempts; $attempt++) {
    try {
        # 发起GET请求
        $response = Invoke-RestMethod -Uri $url -Method Get

        # 获取消息字段的值
        $message = $response.message

        # 检查消息是否为期望的字符串
        if ($message -eq "Hello, this is a simple RESTful API!") {
            Write-Host "Response content is as expected."
            break  # 跳出循环，因为成功了
        } else {
            Write-Host "Response content does not match the expected string. Retrying..."
        }
    } catch {
        Write-Host "Request failed. Retrying in 5 seconds..."
        Start-Sleep -Seconds 5
    }
}
docker run -d --name test1 --network host --env-file .sql.env  databasesystem-database
docker run -d --name test2 --network host databasesystem-nodejs-app
while ($true) {
    try {
        # Run MySQL command and capture the output
        $output = docker exec -it test1 mysql -h 127.0.0.1 -P 3306 2>&1

        # Check if the output contains the access denied error
        if ($output -match "Access denied for user 'root'@'127.0.0.1'") {
            Write-Host "Connection successful"
            break
        } else {
            Write-Host "Connection error: $output"
        }
    } catch {
        Write-Host "Error: $_"
    }

    # Wait for one second before the next iteration
    Start-Sleep -Seconds 3
}
docker run --rm -v ${PWD}/python/result:/opt/apps/test/python/result  --network host databasesystem-python pytest --junitxml=/opt/apps/test/python/result/test-results.xml --json=/opt/apps/test/python/result/test-results.json --html=/opt/apps/test/python/result/report.html --self-contained-html
Start-Process -FilePath "${PWD}/python/result/report.html"
# Stop the container
docker stop test1
docker stop test2
# Remove the container
docker rm test1
docker rm test2

