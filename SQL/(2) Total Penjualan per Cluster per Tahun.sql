select
extract(year from p."createdAt"::timestamp) as tahun, -- ambil tahun transaksi dari createdAt tapi cast ke timestamp dulu karena kolomnya masih varchar
c.name as cluster_name,
sum(p."grandTotal") as total_penjualan
from payments p
join packages pk on p."packageId" = pk.id -- hubungkan payments ke packages dulu
join clusters c on pk."clusterId" = c.id -- baru packages ke clusters, karena cluster gak ada relasi langsung ke payments
where p.status = 'success'
group by tahun, c.name -- kelompokkan per kombinasi tahun & cluster, bukan cuma salah satu
order by tahun asc, total_penjualan desc;  -- urutan bertingkat: tahun makin baru di bawah, dalam tahun yang sama cluster top spender di atas