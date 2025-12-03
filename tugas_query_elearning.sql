-- Buatkan query untuk menampilkan report ini :

-- 1. Jumlah siswa per kelas

SELECT classroom_id, (SELECT name FROM classrooms WHERE id = classroom_students.classroom_id) AS classroom_name, count(student_id) as jumlah_siswa 
FROM classroom_students 
GROUP BY classroom_id
ORDER BY classroom_id;

-- 2. Daftar mentor per kelas

SELECT classroom_id, (SELECT name FROM classrooms WHERE id = classroom_mentors.classroom_id) AS classroom_name, count(mentor_id) as jumlah_mentor
FROM classroom_mentors
GROUP BY classroom_id
ORDER BY classroom_id;

-- 3. Kehadiran siswa per jadwal (schedule)

SELECT schedule_id, (SELECT topic FROM schedules WHERE id = attendances.schedule_id) AS topic, count(status) as hadir
FROM attendances
WHERE status='present'
GROUP BY schedule_id
ORDER BY schedule_id;

-- 4. Rekap kehadiran mingguan/bulanan per siswa

SELECT user_id, (SELECT name FROM users WHERE id = attendances.user_id) AS nama, date_trunc('week', checked_at) AS minggu, count(status) as jumlah_hadir
FROM attendances
WHERE status='present'
GROUP BY user_id, date_trunc('week', checked_at)
ORDER BY minggu;

-- 5. Daftar materi yang digunakan per kelas

SELECT classroom_id, (SELECT name FROM classrooms WHERE id = material_classrooms.classroom_id) AS kelas, material_id, (SELECT title FROM materials WHERE id = material_classrooms.material_id) AS judul_materi
FROM material_classrooms
GROUP BY classroom_id, material_id
ORDER BY classroom_id;

-- 6. Daftar assignment per kelas + deadline + pembuat + jumlah submission

SELECT classroom_id, (SELECT name FROM classrooms WHERE id = assignments.classroom_id) AS kelas, title as judul_tugas , deadline, (SELECT name FROM users WHERE id = assignments.created_by) AS created_by, (SELECT count(*) FROM assignment_submissions WHERE assignment_id = assignments.id) AS jumlah_submision
FROM assignments
ORDER BY classroom_id;

-- 7. Riwayat submission tugas per siswa

SELECT
  student_id,
  (SELECT name FROM users WHERE id = assignment_submissions.student_id) AS nama_siswa,
  assignment_id,
  (SELECT title FROM assignments WHERE id = assignment_submissions.assignment_id) AS judul_assignment,
  file_url,
  created_at
FROM assignment_submissions
ORDER BY student_id, created_at;

-- 8. Nilai siswa per assignment (grade list)

SELECT
  student_id,
  (SELECT name FROM users WHERE id = grades.student_id) AS nama_siswa,
  assignment_id,
  (SELECT title FROM assignments WHERE id = grades.assignment_id) AS judul_assignment,
  grade,
  feedback
FROM grades
ORDER BY assignment_id, student_id;

-- 9. Rata-rata nilai per siswa dalam satu kelas

SELECT
  student_id,
  (SELECT name FROM users WHERE id = classroom_students.student_id) AS nama_siswa, classroom_id,
  (SELECT name FROM classrooms WHERE id = classroom_students.classroom_id) AS nama_kelas,
  (
    SELECT AVG(g.grade)
    FROM grades g
    WHERE g.student_id = classroom_students.student_id
      AND g.assignment_id IN (
        SELECT id FROM assignments WHERE classroom_id = classroom_students.classroom_id
      )
  ) AS rata_rata_nilai
FROM classroom_students
ORDER BY classroom_id, student_id;

-- 10. Daftar notifikasi per user (read/unread)

SELECT
  user_id,
  (SELECT name FROM users WHERE id = notifications.user_id) AS nama_user,
  title,
  message,
  is_read,
  created_at
FROM notifications
ORDER BY user_id, created_at;