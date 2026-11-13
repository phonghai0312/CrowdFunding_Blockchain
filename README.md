🚀 Decentralized Crowdfunding Smart Contract

📖 Tổng quan dự án (Project Overview)

Dự án này cung cấp một giải pháp gọi vốn phi tập trung (Decentralized Crowdfunding) hoạt động hoàn toàn tự động trên nền tảng Blockchain. Hợp đồng thông minh được thiết kế theo mô hình "All-or-Nothing" (Được ăn cả, ngã về không), đảm bảo tính minh bạch và an toàn tuyệt đối cho cả Chủ dự án (Creator) và Nhà đầu tư (Backer) mà không cần sự can thiệp của bên thứ ba.

Cơ chế hoạt động cốt lõi:

Kịch bản Thành công: Nếu tổng số tiền huy động đạt hoặc vượt Mục tiêu (Goal) trong Thời hạn (Deadline) quy định, Chủ dự án được phép giải ngân toàn bộ số tiền để thực hiện dự án.

Kịch bản Thất bại: Nếu hết hạn mà chưa đạt Mục tiêu, Chủ dự án không thể can thiệp vào quỹ. Các nhà đầu tư được quyền chủ động rút lại 100% số tiền mà họ đã đóng góp.

⚙️ Công nghệ sử dụng

Ngôn ngữ: Solidity (Version ^0.8.0)

Môi trường triển khai & kiểm thử: Remix IDE

💻 Hướng dẫn Triển khai (Deployment Guide)

Để biên dịch và triển khai (deploy) hợp đồng này trên môi trường giả lập, vui lòng làm theo các bước sau:

Truy cập Remix IDE.

Tạo file Crowdfunding.sol trong thư mục Workspace và dán toàn bộ mã nguồn vào.

Chuyển sang tab Solidity Compiler (hoặc nhấn Ctrl + S / Cmd + S) để biên dịch mã nguồn.

Chuyển sang tab Deploy & Run Transactions:

Tại mục Environment: Chọn Remix VM (Shanghai) hoặc tương đương.

Tại mục Deploy, mở rộng menu (nhấn vào dấu mũi tên trỏ xuống) và nhập 2 tham số khởi tạo:

_goalInEther: Mục tiêu gọi vốn (VD: 10 - tương đương 10 ETH).

_durationInDays: Thời hạn dự án (VD: 1 - tương đương 1 ngày). (Lưu ý phục vụ kiểm thử: Có thể tạm sửa đổi mã nguồn từ days thành seconds để test luồng nhanh).

Nhấn transact để triển khai hợp đồng.

🧪 Các kịch bản Kiểm thử (Testing Scenarios)

Sau khi triển khai, hợp đồng sẽ xuất hiện tại mục Deployed Contracts ở góc dưới cùng bên trái. Sử dụng các tài khoản (Accounts) khác nhau do Remix cung cấp để thực hiện 3 kịch bản dưới đây:

Kịch bản 1: Đóng góp quỹ (Active Campaign)

Mục đích: Kiểm tra tính năng nhận tiền của hợp đồng khi dự án còn thời hạn.

Các bước thực hiện:

Ở menu trên cùng, đổi sang một Ví của nhà đầu tư (VD: Account số 2).

Tại ô Value, nhập số lượng ETH muốn nạp (VD: 2), đổi đơn vị bên cạnh thành Ether.

Cuộn xuống mục Deployed Contracts, mở rộng hợp đồng và nhấn gọi hàm contribute (màu đỏ).

Kết quả mong đợi: Giao dịch thành công. Khi nhấn vào biến public totalRaised (màu xanh), giá trị trả về sẽ tăng lên tương ứng với số tiền vừa nạp.

Kịch bản 2: Giải ngân quỹ (Successful Campaign)

Điều kiện bắt buộc: Thời gian gọi vốn đã kết thúc VÀ tổng tiền quỹ (totalRaised) >= Mục tiêu (goal).

Các bước thực hiện:

Chuyển về Ví của Chủ dự án (Account số 1 - ví đã dùng để bấm deploy hợp đồng).

Đảm bảo ô Value đang được đặt về mức 0.

Nhấn gọi hàm withdrawFunds.

Kết quả mong đợi: Giao dịch thành công. Toàn bộ số tiền trong quỹ được chuyển về số dư (balance) của Ví Chủ dự án. Biến totalRaised tự động reset về 0.

Kịch bản 3: Hoàn tiền (Failed Campaign)

Điều kiện bắt buộc: Thời gian gọi vốn đã kết thúc NHƯNG tổng tiền quỹ (totalRaised) < Mục tiêu (goal).

Các bước thực hiện:

Chuyển về chính xác Ví mà nhà đầu tư đã dùng để nạp tiền lúc trước (VD: Account số 2).

Kiểm tra kỹ ô Value đang để ở mức 0 (Nếu để số khác 0, giao dịch hoàn tiền sẽ bị revert/từ chối).

Nhấn gọi hàm refund.

Kết quả mong đợi: Giao dịch thành công. Hợp đồng tự động hoàn trả số ETH mà ví đó đã đóng góp. Số dư của ví nhà đầu tư hiển thị ở mục Account được cộng lại phần tiền gốc.

🛡️ Tiêu chuẩn Bảo mật (Security Pattern)

Dự án tuân thủ nghiêm ngặt mô hình thiết kế Checks - Effects - Interactions (CEI) để phòng chống lỗ hổng tấn công gọi lại (Reentrancy Attacks).

Trong các hàm thao tác với dòng tiền (withdrawFunds và refund), trạng thái sổ cái của hợp đồng (đưa totalRaised hoặc contributions[msg.sender] về 0) luôn được cập nhật TRƯỚC KHI lệnh chuyển tiền diễn ra, đảm bảo an toàn tối đa cho ngân quỹ của nền tảng.