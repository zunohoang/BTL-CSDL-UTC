# BTL-CSDL-UTC

Khi code thêm gì đấy thì

Tạo nhánh (branch) cho từng tính năng:

```bash
git checkout -b feature/[tên-tính-năng]
```

Commit thường xuyên với message rõ ràng:

```bash
git add .
git commit -m "Thêm script tạo bảng Customers"
```

Đồng bộ với nhánh chính:

```bash
git pull origin main
```

Push lên repository:

```bash
git push origin feature/[tên-tính-năng]
```

Tạo Pull Request trên GitHub để merge vào nhánh chính (main/master)
