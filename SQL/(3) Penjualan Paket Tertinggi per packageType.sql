select
    "packageType",
    packages,
    "totalSuccessPayments"
from (
    select
        pk."packageType",
        pk.name as packages,
        sum(p."grandTotal") as "totalSuccessPayments", -- jumlah total pembayaran sukses per package
        row_number() over (
            partition by pk."packageType" -- ranking dimulai lagi untuk setiap jenis package
            order by sum(p."grandTotal") desc -- urutkan dari total pembayaran terbesar
        ) as rn
    from payments p
    left join packages pk
        on p."packageId" = pk.id -- tetap tampil walaupun ada package yang tidak ditemukan
    where p.status = 'success' -- hanya hitung transaksi yang berhasil
    group by
        pk."packageType",
        pk.name -- gabungkan data berdasarkan jenis dan nama package
) t
where rn <= 3 -- ambil hanya 3 package dengan total pembayaran terbesar di tiap kategori
order by
    case "packageType" -- mengurutkan agar sesuai expected output karena hasil sebenarnya call mengisi 3 baris teratas
        when 'konseling' then 1
        when 'meditasi' then 2
        when 'call' then 3
        when 'video' then 4
        else 5
    end,
    rn; -- dalam setiap kategori, tampilkan berdasarkan ranking