select "userId", 
sum("grandTotal") as total_spend -- untuk menghitung total pengeluaran setiap user
from payments 
where status = 'success' --hanya yang statusnya success
group by "userId"  --pakai group by karena sum butuh dikelompokkan per userId
order by total_spend desc  
limit 10; --tampilkan 10 user dengan spend tertinggi (top spender)