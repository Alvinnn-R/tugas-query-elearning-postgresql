-- Query Create Tabel

-- -- ENUM for users.status
-- CREATE TYPE user_status AS ENUM ('active', 'inactive', 'banned');

-- -- ENUM for attendances.status
-- CREATE TYPE attendance_status AS ENUM ('present', 'absent', 'late');

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR,
    email VARCHAR UNIQUE,
    password VARCHAR,
    role VARCHAR,
    status user_status,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE classrooms (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR,
    description TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE classroom_mentors (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    mentor_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE classroom_students (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    student_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE schedules (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    topic VARCHAR,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE materials (
    id BIGSERIAL PRIMARY KEY,
    title VARCHAR,
    file_url TEXT,
    uploaded_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE material_classrooms (
    id BIGSERIAL PRIMARY KEY,
    material_id BIGINT REFERENCES materials(id) ON DELETE CASCADE,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    created_at TIMESTAMP
);


CREATE TABLE attendances (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT REFERENCES schedules(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    status attendance_status,
    checked_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE assignments (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    title VARCHAR,
    description TEXT,
    file_url TEXT,
    deadline TIMESTAMP,
    created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE assignment_submissions (
    id BIGSERIAL PRIMARY KEY,
    assignment_id BIGINT REFERENCES assignments(id) ON DELETE CASCADE,
    student_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    file_url TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE grades (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    assignment_id BIGINT REFERENCES assignments(id) ON DELETE CASCADE,
    grade DECIMAL,
    feedback TEXT,
    graded_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    graded_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE announcements (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    created_by BIGINT REFERENCES users(id) ON DELETE SET NULL,
    title VARCHAR,
    message TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE discussions (
    id BIGSERIAL PRIMARY KEY,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    parent_id BIGINT REFERENCES discussions(id) ON DELETE CASCADE,
    content TEXT,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);


CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    announcement_id BIGINT REFERENCES announcements(id) ON DELETE CASCADE,
    discussion_id BIGINT REFERENCES discussions(id) ON DELETE CASCADE,
    title VARCHAR,
    message TEXT,
    is_read BOOLEAN,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE feedbacks (
    id BIGSERIAL PRIMARY KEY,
    from_user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    to_user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    classroom_id BIGINT REFERENCES classrooms(id) ON DELETE CASCADE,
    rating INT,
    comment TEXT,
    created_at TIMESTAMP
);
