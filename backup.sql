--
-- PostgreSQL database dump
--

\restrict QWQEcThPpIzf4j8Kckdr6fV7IYyOJuTUjjnMxjARkCLrZ6o3D4nTdyy3DbCJyBe

-- Dumped from database version 18.0 (Debian 18.0-1.pgdg13+3)
-- Dumped by pg_dump version 18.0 (Debian 18.0-1.pgdg13+3)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: imaad
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW.updated_at = NOW();
RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO imaad;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_years; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.academic_years (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_current boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.academic_years OWNER TO imaad;

--
-- Name: antidigital_djf; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.antidigital_djf (
    output text
);


ALTER TABLE public.antidigital_djf OWNER TO imaad;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.attendance (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    class_id uuid NOT NULL,
    date date NOT NULL,
    status character varying(10) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    CONSTRAINT attendance_status_check CHECK (((status)::text = ANY ((ARRAY['present'::character varying, 'absent'::character varying, 'late'::character varying])::text[])))
);


ALTER TABLE public.attendance OWNER TO imaad;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.categories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.categories OWNER TO imaad;

--
-- Name: class_papers; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.class_papers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    paper_id uuid NOT NULL,
    teacher_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.class_papers OWNER TO imaad;

--
-- Name: class_promotions; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.class_promotions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    from_class_id uuid NOT NULL,
    to_class_id uuid NOT NULL,
    academic_year_id uuid,
    promotion_criteria text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.class_promotions OWNER TO imaad;

--
-- Name: class_subjects; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.class_subjects (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    is_compulsory boolean DEFAULT true
);


ALTER TABLE public.class_subjects OWNER TO imaad;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.classes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(255) NOT NULL,
    teacher_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone,
    code character varying(20) NOT NULL
);


ALTER TABLE public.classes OWNER TO imaad;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.departments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    head_of_department_id uuid,
    assistant_head_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.departments OWNER TO imaad;

--
-- Name: exams; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.exams (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    class_id uuid NOT NULL,
    academic_year_id uuid,
    term_id uuid,
    paper_id uuid NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.exams OWNER TO imaad;

--
-- Name: expenses; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.expenses (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    category_id uuid NOT NULL,
    title character varying(100) NOT NULL,
    amount numeric(10,2) NOT NULL,
    date date NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.expenses OWNER TO imaad;

--
-- Name: fee_type_assignments; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.fee_type_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    fee_type_id uuid NOT NULL,
    class_id uuid,
    student_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT fee_type_assignments_check CHECK ((((class_id IS NOT NULL) AND (student_id IS NULL)) OR ((class_id IS NULL) AND (student_id IS NOT NULL))))
);


ALTER TABLE public.fee_type_assignments OWNER TO imaad;

--
-- Name: fee_types; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.fee_types (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    payment_frequency character varying(20) NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    amount integer DEFAULT 0,
    scope character varying(50) DEFAULT 'manual'::character varying,
    CONSTRAINT fee_types_payment_frequency_check CHECK (((payment_frequency)::text = ANY ((ARRAY['once'::character varying, 'per_term'::character varying, 'per_year'::character varying, 'on_demand'::character varying])::text[])))
);


ALTER TABLE public.fee_types OWNER TO imaad;

--
-- Name: fees; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.fees (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    fee_type_id uuid NOT NULL,
    academic_year_id uuid,
    term_id uuid,
    title character varying(100) NOT NULL,
    amount numeric(10,2) NOT NULL,
    balance numeric(10,2) DEFAULT 0,
    currency character varying(3) DEFAULT 'USD'::character varying NOT NULL,
    paid boolean DEFAULT false,
    due_date date NOT NULL,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.fees OWNER TO imaad;

--
-- Name: grades; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.grades (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(10) NOT NULL,
    min_marks numeric(5,2) NOT NULL,
    max_marks numeric(5,2) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.grades OWNER TO imaad;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.notifications (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    subject character varying(255) NOT NULL,
    body text NOT NULL,
    recipient_id uuid NOT NULL,
    recipient_type character varying(20) NOT NULL,
    email character varying(255) NOT NULL,
    is_sent boolean DEFAULT false,
    sent_at timestamp with time zone,
    template character varying(100),
    retry_count integer DEFAULT 0,
    attachment_urls text[],
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.notifications OWNER TO imaad;

--
-- Name: papers; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.papers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    subject_id uuid NOT NULL,
    code character varying(20) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    name character varying DEFAULT ''::character varying NOT NULL,
    is_compulsory boolean DEFAULT true
);


ALTER TABLE public.papers OWNER TO imaad;

--
-- Name: parents; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.parents (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(20),
    email character varying(255),
    address text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.parents OWNER TO imaad;

--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.password_reset_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    used_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.password_reset_tokens OWNER TO imaad;

--
-- Name: payment_allocations; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.payment_allocations (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    payment_id uuid NOT NULL,
    fee_type_id uuid NOT NULL,
    amount numeric(10,2) NOT NULL,
    balance numeric(10,2) DEFAULT 0,
    is_fully_paid boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    fee_id uuid
);


ALTER TABLE public.payment_allocations OWNER TO imaad;

--
-- Name: payments; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.payments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    payment_date date NOT NULL,
    payment_method character varying(50),
    paid_by uuid NOT NULL,
    transaction_id character varying(255),
    status character varying(20) DEFAULT 'pending'::character varying,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.payments OWNER TO imaad;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.permissions OWNER TO imaad;

--
-- Name: results; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.results (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    exam_id uuid NOT NULL,
    student_id uuid NOT NULL,
    paper_id uuid NOT NULL,
    marks numeric(5,2) NOT NULL,
    grade_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.results OWNER TO imaad;

--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.role_permissions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.role_permissions OWNER TO imaad;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.roles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.roles OWNER TO imaad;

--
-- Name: schedules; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.schedules (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    teacher_id uuid NOT NULL,
    day character varying(10) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.schedules OWNER TO imaad;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.sessions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sessions OWNER TO imaad;

--
-- Name: student_parents; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.student_parents (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    parent_id uuid NOT NULL,
    relationship character varying(20) NOT NULL,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.student_parents OWNER TO imaad;

--
-- Name: students; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.students (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    date_of_birth date,
    gender character varying(10),
    address text,
    class_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone,
    CONSTRAINT students_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.students OWNER TO imaad;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.subjects (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(20) NOT NULL,
    department_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.subjects OWNER TO imaad;

--
-- Name: teacher_availability; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.teacher_availability (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    teacher_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    is_available boolean DEFAULT true NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.teacher_availability OWNER TO imaad;

--
-- Name: teacher_subjects; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.teacher_subjects (
    teacher_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    paper_id uuid
);


ALTER TABLE public.teacher_subjects OWNER TO imaad;

--
-- Name: terms; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.terms (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    academic_year_id uuid NOT NULL,
    name character varying(100) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_current boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone
);


ALTER TABLE public.terms OWNER TO imaad;

--
-- Name: timetable_entries; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.timetable_entries (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    class_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    teacher_id uuid NOT NULL,
    paper_id uuid,
    day_of_week character varying(10) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    CONSTRAINT timetable_entries_day_of_week_check CHECK (((day_of_week)::text = ANY ((ARRAY['monday'::character varying, 'tuesday'::character varying, 'wednesday'::character varying, 'thursday'::character varying, 'friday'::character varying, 'saturday'::character varying, 'sunday'::character varying])::text[])))
);


ALTER TABLE public.timetable_entries OWNER TO imaad;

--
-- Name: timetable_settings; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.timetable_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    class_id character varying(255),
    days text DEFAULT '["monday","tuesday","wednesday","thursday","friday"]'::text NOT NULL,
    start_time time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    end_time time without time zone DEFAULT '16:00:00'::time without time zone NOT NULL,
    lesson_duration integer DEFAULT 60 NOT NULL,
    breaks text DEFAULT '[]'::text NOT NULL,
    is_default boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.timetable_settings OWNER TO imaad;

--
-- Name: user_departments; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.user_departments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    department_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.user_departments OWNER TO imaad;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    deleted_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO imaad;

--
-- Name: users; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    phone character varying(20),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO imaad;

--
-- Name: vinc; Type: TABLE; Schema: public; Owner: imaad
--

CREATE TABLE public.vinc (
    output text
);


ALTER TABLE public.vinc OWNER TO imaad;

--
-- Data for Name: academic_years; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.academic_years (id, name, start_date, end_date, is_current, is_active, created_at, updated_at, deleted_at) FROM stdin;
18ec3760-d96b-4471-947a-d0702dd3edb6	2024-2025	2024-01-01	2024-12-31	t	f	2025-11-11 19:24:33.659311+00	2025-11-11 20:31:29.18082+00	\N
ecc6100b-c082-48df-9404-b6b44cca757a	2025-2026	2025-01-01	2025-12-25	f	f	2025-11-11 20:05:19.280456+00	2025-11-11 20:31:29.18082+00	2025-11-11 20:28:47.883526+00
457b88c8-63c4-402a-a2e2-c39d46d64409	2025	2025-01-21	2025-12-20	f	t	2025-11-11 20:31:29.18082+00	2025-11-11 20:31:29.18082+00	\N
\.


--
-- Data for Name: antidigital_djf; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.antidigital_djf (output) FROM stdin;
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.attendance (id, student_id, class_id, date, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.categories (id, name, is_active, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: class_papers; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.class_papers (id, class_id, paper_id, teacher_id, is_active, created_at, updated_at, deleted_at) FROM stdin;
9265ed64-bc57-4a22-8458-d6bb805edd25	6132551e-91a2-4685-9702-5726be5eba43	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	798b1752-83d0-416c-a097-056328c7d56c	t	2025-11-07 15:45:09.372771+00	2025-11-07 15:45:09.372771+00	\N
6b098a68-daa6-4bd3-a31e-1c8843a29df9	6132551e-91a2-4685-9702-5726be5eba43	84a89914-57d1-47fd-a94d-04dd9839d555	77d5ac90-58e3-4257-bc55-f04e417a4601	t	2025-11-07 15:45:30.167075+00	2025-11-07 15:45:30.167075+00	\N
14e02872-09ed-4ed5-8cba-1c34765e1398	6132551e-91a2-4685-9702-5726be5eba43	471cce99-01a8-4378-8b56-996c88549784	4dd408fa-7666-4d4c-b8e2-251e999f3175	t	2025-11-08 06:58:16.381445+00	2025-11-08 06:58:16.381445+00	\N
0aca48a1-b6fc-4605-9f73-39287c053632	6132551e-91a2-4685-9702-5726be5eba43	d755d10b-c757-408a-827c-8d8db0950375	cbe8de30-0d7f-4f0b-bb7c-abbd4d6ea192	t	2025-11-08 06:58:32.764613+00	2025-11-08 06:58:32.764613+00	\N
6f106d9b-232d-42d2-a275-afaa1537deb1	67f6fc2a-deb5-408c-8ac7-975730d9cb70	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	5fa24ba5-d4c3-4480-97de-a42f7706c79a	t	2025-11-08 06:59:23.466446+00	2025-11-08 06:59:23.466446+00	\N
ce67c775-69a7-405a-b49b-ea8cc0786589	67f6fc2a-deb5-408c-8ac7-975730d9cb70	84a89914-57d1-47fd-a94d-04dd9839d555	ba753ca4-bee9-4aab-981e-6fb1ac85b20c	t	2025-11-08 06:59:42.375802+00	2025-11-08 06:59:42.375802+00	\N
967aec2b-5eda-4843-967b-42c8064c9b49	67f6fc2a-deb5-408c-8ac7-975730d9cb70	471cce99-01a8-4378-8b56-996c88549784	8dfb246c-c3ff-411e-aecd-2fa9ef426afe	t	2025-11-08 07:00:10.569343+00	2025-11-08 07:00:10.569343+00	\N
64c8e04e-7f32-4581-84bf-faf98e3f0e9c	67f6fc2a-deb5-408c-8ac7-975730d9cb70	d755d10b-c757-408a-827c-8d8db0950375	4dd408fa-7666-4d4c-b8e2-251e999f3175	t	2025-11-08 07:00:32.867168+00	2025-11-08 07:00:32.867168+00	\N
a7186129-2d51-4c8d-b699-721538f6cc98	e455acf0-395b-4236-8ce0-ad5fc972d19b	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	5fa24ba5-d4c3-4480-97de-a42f7706c79a	t	2025-11-08 07:22:09.159329+00	2025-11-08 07:22:09.159329+00	\N
39f761b3-8bbc-44b9-bde6-a2673e1e5e4e	e455acf0-395b-4236-8ce0-ad5fc972d19b	84a89914-57d1-47fd-a94d-04dd9839d555	8dfb246c-c3ff-411e-aecd-2fa9ef426afe	t	2025-11-08 07:23:52.169149+00	2025-11-08 07:23:52.169149+00	\N
\.


--
-- Data for Name: class_promotions; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.class_promotions (id, from_class_id, to_class_id, academic_year_id, promotion_criteria, is_active, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: class_subjects; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.class_subjects (id, class_id, subject_id, created_at, deleted_at, is_compulsory) FROM stdin;
e55fbafd-9b6f-41c6-9df3-86377122c358	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	2025-11-07 15:45:09.372771+00	\N	t
576e02bb-de1c-4a3b-a1ef-5e97308f7503	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	2025-11-07 15:45:30.167075+00	\N	t
573c5121-a6d6-455e-b894-ed5a1fe54673	6132551e-91a2-4685-9702-5726be5eba43	6808b921-e9ba-4abe-9c56-9c061bf88537	2025-11-08 06:58:16.381445+00	\N	t
4d38191b-51e1-4eab-8055-ad4de92dfbf3	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	2025-11-08 06:58:32.764613+00	\N	t
b3b7fda6-483d-4ee9-ae39-896ab1fc3f87	67f6fc2a-deb5-408c-8ac7-975730d9cb70	746b5667-0805-4745-977a-c8e2f9d4995a	2025-11-08 06:59:23.466446+00	\N	t
a53d8223-7feb-403a-a2c0-eff43cffb37b	67f6fc2a-deb5-408c-8ac7-975730d9cb70	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	2025-11-08 06:59:42.375802+00	\N	t
c8a9d7be-6df2-49eb-b1a3-eb0c91f63ff8	67f6fc2a-deb5-408c-8ac7-975730d9cb70	6808b921-e9ba-4abe-9c56-9c061bf88537	2025-11-08 07:00:10.569343+00	\N	t
426d4dd8-8749-4652-b47a-1b031de1f135	67f6fc2a-deb5-408c-8ac7-975730d9cb70	39c95292-248f-4786-a8e1-8cf8a0e125e8	2025-11-08 07:00:32.867168+00	\N	t
3509b8c4-2a7e-458d-a8f1-395b4aeeb4de	e455acf0-395b-4236-8ce0-ad5fc972d19b	746b5667-0805-4745-977a-c8e2f9d4995a	2025-11-08 07:22:09.159329+00	\N	t
f0f25b81-911f-4ed1-993a-239c24217c7a	e455acf0-395b-4236-8ce0-ad5fc972d19b	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	2025-11-08 07:23:52.169149+00	\N	t
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.classes (id, name, teacher_id, is_active, created_at, updated_at, deleted_at, code) FROM stdin;
6132551e-91a2-4685-9702-5726be5eba43	Primary-1	798b1752-83d0-416c-a097-056328c7d56c	t	2025-10-23 20:02:23.984437	2025-10-30 00:01:25.272198	\N	P-1
e455acf0-395b-4236-8ce0-ad5fc972d19b	Primary-3	5fa24ba5-d4c3-4480-97de-a42f7706c79a	t	2025-10-30 00:04:20.522779	2025-10-30 00:04:20.522779	\N	P-3
a93a538e-9879-45de-8fb0-8a1709ddbdfb	Primary-4	4dd408fa-7666-4d4c-b8e2-251e999f3175	t	2025-10-30 00:04:57.590113	2025-10-30 00:04:57.590113	\N	P-4
746a6e69-a337-4d3a-9050-fec30acae340	Primary-5	77d5ac90-58e3-4257-bc55-f04e417a4601	t	2025-10-30 00:06:02.139025	2025-10-30 00:06:02.139025	\N	P-5
03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	Primary-7	8dfb246c-c3ff-411e-aecd-2fa9ef426afe	t	2025-10-30 00:10:23.439601	2025-10-30 00:22:27.493924	\N	P-7
0446f859-3fe7-4148-a5b0-b2732fb505ee	Primary-6	f389b565-0c15-44bd-9748-8fe1ff20bc67	t	2025-10-30 00:08:28.464654	2025-10-30 00:45:10.473128	\N	P-6
67f6fc2a-deb5-408c-8ac7-975730d9cb70	Primary-2	2f5932e3-af2e-413e-8bc4-59113d16a366	t	2025-10-29 13:14:42.310694	2025-10-30 14:12:39.636387	\N	P-2
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.departments (id, name, code, description, head_of_department_id, assistant_head_id, is_active, created_at, updated_at, deleted_at) FROM stdin;
225609db-adf9-4c55-83fb-5e880dd9481e	Science	SCI	Science	77d5ac90-58e3-4257-bc55-f04e417a4601	2f5932e3-af2e-413e-8bc4-59113d16a366	t	2025-10-24 16:52:20.542226+00	2025-10-24 16:52:20.542226+00	\N
dc13b32b-cb13-4fef-9d38-79b24f6c6b60	Social Studies	SST	Social Studies	77d5ac90-58e3-4257-bc55-f04e417a4601	2f5932e3-af2e-413e-8bc4-59113d16a366	t	2025-10-24 16:54:17.480499+00	2025-10-24 16:54:17.480499+00	\N
1d0663c9-f914-4ba5-baa8-453a768886f0	Mathematics	MATH	Mathematics	5fa24ba5-d4c3-4480-97de-a42f7706c79a	77d5ac90-58e3-4257-bc55-f04e417a4601	t	2025-10-23 18:26:52.68486+00	2025-11-07 16:52:49.083431+00	\N
2b93eb17-fba0-46d7-ae2b-80ba652faacc	English	ENG	English	77d5ac90-58e3-4257-bc55-f04e417a4601	2f5932e3-af2e-413e-8bc4-59113d16a366	t	2025-10-24 16:53:29.563363+00	2025-11-07 18:40:23.768447+00	\N
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.exams (id, name, class_id, academic_year_id, term_id, paper_id, start_time, end_time, is_active, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: expenses; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.expenses (id, category_id, title, amount, date, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: fee_type_assignments; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.fee_type_assignments (id, fee_type_id, class_id, student_id, created_at) FROM stdin;
50f4b19b-ceaf-4641-a8b3-f5382bfe783c	8af84433-4392-4296-b041-cffbdea8c987	67f6fc2a-deb5-408c-8ac7-975730d9cb70	\N	2025-11-08 23:15:48.659545+00
198232a5-f01f-42a3-9271-14f4f57ac651	aa9714e7-9c7d-4059-884a-affb5d53ae26	6132551e-91a2-4685-9702-5726be5eba43	\N	2025-11-11 16:07:33.65954+00
ecafb273-806b-4a58-b64c-5145f7e0d3fe	d5310cc6-0d10-4af4-98fd-5365c0ecc166	e455acf0-395b-4236-8ce0-ad5fc972d19b	\N	2025-11-12 21:50:08.858987+00
8a46ca54-8bee-488f-a53e-8354f6c1c3d4	dd50f8d7-543c-4d01-a7e9-0d2dc88a61d0	a93a538e-9879-45de-8fb0-8a1709ddbdfb	\N	2025-11-12 21:51:24.359056+00
1425af6e-4646-491e-8d55-a0fd0c430b09	85f7c71e-e6ed-4669-aae5-bd9507999f50	746a6e69-a337-4d3a-9050-fec30acae340	\N	2025-11-12 21:52:58.35992+00
5711518a-a833-4367-a973-505ab5a207ba	f4f9066e-4bca-42ec-bb7b-f2639613387d	0446f859-3fe7-4148-a5b0-b2732fb505ee	\N	2025-11-12 21:53:59.458989+00
42537fe2-cdfc-4538-bc9f-d575bd152203	3f41ace5-cc7d-4d12-a0b4-669eb2cba8c7	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	\N	2025-11-12 21:56:56.658927+00
\.


--
-- Data for Name: fee_types; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.fee_types (id, name, code, description, is_active, created_at, updated_at, deleted_at, payment_frequency, is_required, amount, scope) FROM stdin;
8af84433-4392-4296-b041-cffbdea8c987	School Fees P-2	SFP-2	schools for P-2	t	2025-11-08 23:15:48.061053+00	2025-11-08 23:15:48.061053+00	\N	per_term	t	300000	class
d5310cc6-0d10-4af4-98fd-5365c0ecc166	School Fees P-3	SFP-3	schools fees for P-3	t	2025-11-12 21:50:07.759329+00	2025-11-12 21:50:07.759329+00	\N	per_term	t	400000	class
dd50f8d7-543c-4d01-a7e9-0d2dc88a61d0	School Fees P-4	SFP-4	school fees for P-4	t	2025-11-12 21:51:23.758925+00	2025-11-12 21:51:23.758925+00	\N	per_term	t	450000	class
85f7c71e-e6ed-4669-aae5-bd9507999f50	School Fees P-5	SFP-5	school fees for P-5	t	2025-11-12 21:52:57.75997+00	2025-11-12 21:52:57.75997+00	\N	per_term	t	500000	class
f4f9066e-4bca-42ec-bb7b-f2639613387d	School Fees P-6	SFP-6	school fees for P-6	t	2025-11-12 21:53:58.774999+00	2025-11-12 21:53:58.774999+00	\N	per_term	t	550000	class
3f41ace5-cc7d-4d12-a0b4-669eb2cba8c7	School Fees P-7	SFP-7	school fees for P-7	t	2025-11-12 21:56:56.080458+00	2025-11-12 21:56:56.080458+00	\N	per_term	t	600000	class
aa9714e7-9c7d-4059-884a-affb5d53ae26	School Fees P-1	SFP-1	school fees for P-1	t	2025-11-08 22:41:40.759178+00	2025-11-18 14:49:01.131462+00	\N	per_term	t	320000	class
\.


--
-- Data for Name: fees; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.fees (id, student_id, fee_type_id, academic_year_id, term_id, title, amount, balance, currency, paid, due_date, paid_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.grades (id, name, min_marks, max_marks, is_active, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.notifications (id, subject, body, recipient_id, recipient_type, email, is_sent, sent_at, template, retry_count, attachment_urls, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: papers; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.papers (id, subject_id, code, is_active, created_at, updated_at, deleted_at, name, is_compulsory) FROM stdin;
f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	746b5667-0805-4745-977a-c8e2f9d4995a	ENG-1	t	2025-10-25 02:28:08.573602+00	2025-11-06 20:51:06.269737+00	\N	English Paper 1	t
84a89914-57d1-47fd-a94d-04dd9839d555	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	MAT-1	t	2025-11-06 20:52:33.160332+00	2025-11-06 20:55:41.379459+00	\N	Mathematics paper 1	t
471cce99-01a8-4378-8b56-996c88549784	6808b921-e9ba-4abe-9c56-9c061bf88537	SCI-1	t	2025-11-06 20:53:23.159277+00	2025-11-06 20:55:41.379459+00	\N	Science paper 1	t
d755d10b-c757-408a-827c-8d8db0950375	39c95292-248f-4786-a8e1-8cf8a0e125e8	SST-1	t	2025-11-06 20:54:04.759167+00	2025-11-06 20:55:41.379459+00	\N	Social Studies Paper 1	t
\.


--
-- Data for Name: parents; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.parents (id, first_name, last_name, phone, email, address, is_active, created_at, updated_at, deleted_at) FROM stdin;
c23c714f-c948-4dfa-8739-f8ee2a7d8582	imaad	muniir	+256700752104	imaad.ssebintu@gmail.com	kamapal	t	2025-10-23 20:27:28.595949+00	2025-10-23 20:27:28.595949+00	\N
e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Jane	Doe	0987654321	jane.doe@example.com	456 Oak Ave, Anytown, USA	t	2025-10-29 12:43:26.984402+00	2025-10-29 12:43:26.984402+00	\N
c59d764e-772e-427d-b739-e81c80b69c02	Valerie	White	001-561-527-2638	livingstoncalvin@example.net	3674 Smith Cove Suite 565, Lake Ronaldburgh, MN 04033	t	2025-10-29 12:50:01.276694+00	2025-10-29 12:50:01.276694+00	\N
a913fdaa-c9d8-444f-8cc0-4ddb845a67c7	Julie	Miller	(615)643-4456x25682	daniel58@example.org	7922 Peterson Oval Apt. 104, Swansonview, KY 76396	t	2025-10-29 12:50:02.202645+00	2025-10-29 12:50:02.202645+00	\N
f8235b4d-9f51-4297-9225-1ec363ee1804	Gregory	Huang	(547)753-1572	sydneymartin@example.com	93941 Zimmerman Fields, Wilkinsstad, WV 21764	t	2025-10-29 12:50:03.110663+00	2025-10-29 12:50:03.110663+00	\N
fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Kimberly	Davis	+1-469-684-5465	acastro@example.org	3371 Sharon Point, Lake William, IL 84791	t	2025-10-29 12:51:28.727314+00	2025-10-29 12:51:28.727314+00	\N
d508f392-39ca-42ab-982a-1d6f6bb2f73c	Jerry	Allen	207.671.6121x891	olivia53@example.org	0250 Krista Lodge Suite 287, Robertshire, TN 38814	t	2025-10-29 12:51:30.397286+00	2025-10-29 12:51:30.397286+00	\N
3bf3de62-f9cc-40a8-a28a-6d86671386da	Joann	Carroll	(763)269-8418x63496	cathywhite@example.com	371 Cummings Square, North Amanda, GA 09010	t	2025-10-29 12:51:31.314325+00	2025-10-29 12:51:31.314325+00	\N
b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Sara	Taylor	569-375-6117x28790	yhenderson@example.net	80681 Anthony Walk, West Jonmouth, DC 49965	t	2025-10-29 12:51:32.229288+00	2025-10-29 12:51:32.229288+00	\N
4a45a9e3-5989-4960-9f4d-9d07bd64d392	Jacqueline	Cook	(861)405-8885	jeremy65@example.com	USNS Rios, FPO AP 99511	t	2025-10-29 12:51:33.140766+00	2025-10-29 12:51:33.140766+00	\N
825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Michelle	Stevenson	654-540-9990x70964	kirk11@example.org	USS Turner, FPO AP 55226	t	2025-10-29 12:51:34.050776+00	2025-10-29 12:51:34.050776+00	\N
be67f17c-1ab7-432e-9c92-5e17c9f95aa7	Dawn	Mcclain	895.736.1149	nmorris@example.org	USNV Davis, FPO AP 81514	t	2025-10-29 12:51:34.959391+00	2025-10-29 12:51:34.959391+00	\N
8c0c3dfd-0e58-42ce-b190-1706fb49bbb3	Bruce	Fitzgerald	6018558446	ashley90@example.org	2357 Goodwin Coves Apt. 633, West Johnny, UT 73983	t	2025-10-29 12:51:35.87246+00	2025-10-29 12:51:35.87246+00	\N
c9681e39-87da-49a1-b1a9-65e03c7b279e	Matthew	Vargas	2817382968	fischersonya@example.com	83787 Janet Lock Apt. 235, Rodriguezshire, AR 68095	t	2025-10-29 12:51:36.785778+00	2025-10-29 12:51:36.785778+00	\N
018b4718-12d4-40fd-9813-b180e462d4ab	David	Cunningham	280.304.3586x952	ycasey@example.org	PSC 0988, Box 7017, APO AE 38669	t	2025-10-29 12:51:37.697749+00	2025-10-29 12:51:37.697749+00	\N
010e3349-ad39-4049-ba39-77661a15d21f	Amanda	Thompson	614-450-9706x1359	juliansalazar@example.org	9959 Nichols Stream, Ritaport, NE 62331	t	2025-10-29 12:51:38.611321+00	2025-10-29 12:51:38.611321+00	\N
1acf82c7-baf7-43c5-956f-814a767c39b6	Evan	Cooper	7632688730	martinezjennifer@example.org	1367 Brown Street Apt. 478, Port Jessicamouth, MA 80861	t	2025-10-29 12:51:40.433623+00	2025-10-29 12:51:40.433623+00	\N
260ec7d5-49c2-4ff4-8ec5-7240b7749636	Bonnie	Tucker	487.427.6551x28991	fitzgeraldscott@example.net	473 Long Lake Suite 019, Port Jessicaview, MT 99506	t	2025-10-29 12:51:41.349189+00	2025-10-29 12:51:41.349189+00	\N
c5953105-0d05-43c5-9cea-287b806232fa	David	Fuentes	+1-547-683-3387	shahalan@example.com	93890 Emily Manor, Hoffmanmouth, PA 01095	t	2025-10-29 12:51:42.283202+00	2025-10-29 12:51:42.283202+00	\N
91d70c56-984a-4ebc-94db-0ea8fad17649	Nicole	Wilson	001-620-642-6916	qsmith@example.net	5664 Tiffany Summit Apt. 097, Lake Tara, FM 88165	t	2025-10-29 12:51:45.024574+00	2025-10-29 12:51:45.024574+00	\N
efdb08db-a413-42ae-884b-fa5a375dd683	Timothy	Williams	(918)389-4019x43312	umack@example.com	60805 Keith Grove, Woodardshire, PR 45176	t	2025-10-29 12:51:45.9431+00	2025-10-29 12:51:45.9431+00	\N
8898bf9c-65c3-46e8-a89a-b82efa4169e9	Justin	Stafford	(406)557-4514x134	joseph61@example.net	4479 Monique Hollow, Michaelland, RI 37053	t	2025-10-29 12:51:46.852109+00	2025-10-29 12:51:46.852109+00	\N
4dbf793e-cd98-4829-9bf8-dab48242a9f0	William	Weaver	524-704-8827x691	whiteamanda@example.net	38027 Campbell Ranch, West Chelseaport, MS 37488	t	2025-10-30 14:09:12.969738+00	2025-10-30 14:09:12.969738+00	\N
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.password_reset_tokens (id, email, token, expires_at, used_at, created_at) FROM stdin;
91141b7a-af59-4a67-ac58-5572d36386d1	imaad.ssebintu@gmail.com	c6de97da9d7d2dd6f0e5ca1d8f7c16d058274656f7fefb64b98689d23b70dcbb	2025-11-21 00:56:28.600968	2025-11-20 01:05:37.372981	2025-11-20 00:56:28.600968
\.


--
-- Data for Name: payment_allocations; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.payment_allocations (id, payment_id, fee_type_id, amount, balance, is_fully_paid, created_at, updated_at, deleted_at, fee_id) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.payments (id, student_id, total_amount, payment_date, payment_method, paid_by, transaction_id, status, paid_at, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.permissions (id, name, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.results (id, exam_id, student_id, paper_id, marks, grade_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.role_permissions (id, role_id, permission_id, created_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.roles (id, name, is_active, created_at, updated_at, deleted_at) FROM stdin;
1f1abdb0-49a6-4094-98a9-1d2b2847b58b	admin	t	2025-10-23 16:02:24.119572+00	2025-10-23 16:02:24.119572+00	\N
13876592-9522-4a97-ae49-2af8f1e8432a	head_teacher	t	2025-10-23 16:02:24.119572+00	2025-10-23 16:02:24.119572+00	\N
bf98d846-8bd5-4739-b146-8c46e174cfec	class_teacher	t	2025-10-23 16:02:24.119572+00	2025-10-23 16:02:24.119572+00	\N
9788eee0-2f36-4b6f-a942-af2982da0f89	subject_teacher	t	2025-10-23 16:02:24.119572+00	2025-10-23 16:02:24.119572+00	\N
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.schedules (id, class_id, subject_id, teacher_id, day, start_time, end_time, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.sessions (id, user_id, expires_at, created_at) FROM stdin;
90105cc0-f3d7-45e9-a40a-0ecd18b6593e	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-24 16:12:05.453099+00	2025-10-23 16:12:05.4531+00
9fdc3ac3-f65b-44a9-babc-15836c91c2df	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-25 16:16:18.641458+00	2025-10-24 16:16:18.641458+00
f7eb1b3d-dff0-4327-92c9-30cb17c61f7c	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-25 21:09:35.51389+00	2025-10-24 21:09:35.51389+00
04464f03-0d9e-49f9-b069-9c1894bf405f	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-25 21:35:46.101252+00	2025-10-24 21:35:46.101253+00
03fff6d6-3414-475d-b916-6e5f5b117cd7	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-26 02:03:41.505172+00	2025-10-25 02:03:41.505172+00
2a762b05-8c21-44d5-9ba0-2ada9b3cd1d9	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-26 09:20:47.192727+00	2025-10-25 09:20:47.192728+00
8f8f4651-77ae-489f-885e-d171094e89ed	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-26 20:47:33.678104+00	2025-10-25 20:47:33.678105+00
9e200061-8139-4f3e-9453-6347cb638e4d	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-26 21:08:30.474961+00	2025-10-25 21:08:30.474962+00
7fae442d-97a0-483f-915f-96241bab6404	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-27 23:47:01.49758+00	2025-10-26 23:47:01.49758+00
8d823a59-45e8-4ea1-a98d-ce1481805318	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-28 15:07:51.700552+00	2025-10-27 15:07:51.700553+00
e376876d-1026-43d1-ba6b-d52384d84706	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-29 01:03:26.021385+00	2025-10-28 01:03:26.021386+00
528d6ac3-3553-4fb8-93b8-ed2baed72279	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-29 06:46:26.004591+00	2025-10-28 06:46:26.004592+00
ac37c72a-a221-4dea-9803-c38ed3931023	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-30 05:58:43.36056+00	2025-10-29 05:58:43.36056+00
38a57471-857a-4a62-a86e-88bcd31cfc14	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-30 12:50:20.005349+00	2025-10-29 12:50:20.00535+00
e7bb3290-231a-438b-af9a-e71c0ceba96e	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-31 13:57:16.484724+00	2025-10-30 13:57:16.484725+00
92ebe5d7-6e7c-4466-9914-ac6c8031b40c	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-10-31 15:03:14.947194+00	2025-10-30 15:03:14.947194+00
6b0fc856-5472-4da8-af2a-4cdf221f7404	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-03 18:42:01.259523+00	2025-11-02 18:42:01.259524+00
853aad98-419e-460a-b66a-601bb1a3d3af	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-03 19:16:50.441915+00	2025-11-02 19:16:50.441916+00
13267bc8-1c08-462c-8083-45048bee8059	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-04 01:20:57.579362+00	2025-11-03 01:20:57.579363+00
51d8323e-e6ae-4774-a928-540264a6b42d	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-04 20:42:22.460918+00	2025-11-03 20:42:22.46092+00
8fe01044-c7f5-4b41-9cce-18ced90f8886	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-04 20:50:51.409543+00	2025-11-03 20:50:51.409544+00
ec905861-32fa-439a-9cdc-60b66210eafb	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-06 06:30:25.075016+00	2025-11-05 06:30:25.075017+00
8902d7da-8ee6-4f6f-9ff0-715b19591026	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-06 08:53:46.061948+00	2025-11-05 08:53:46.06195+00
154655df-d17b-48c0-a927-0344bd60cb2d	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-06 11:09:43.823125+00	2025-11-05 11:09:43.823125+00
8c6d62fa-8b5a-42d1-bb70-8923da6f83c3	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-07 13:04:16.16736+00	2025-11-06 13:04:16.167361+00
a8e6ee5e-8690-43e4-8089-fa5074687c31	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-07 20:24:28.261172+00	2025-11-06 20:24:28.261172+00
2d267dc2-260e-4700-a256-9bac3b0d1495	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-08 11:44:23.666241+00	2025-11-07 11:44:23.666242+00
db88de5a-67cc-4319-81ae-7afbbc6ec0e0	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-08 13:48:31.289851+00	2025-11-07 13:48:31.289852+00
92e407f1-5412-452f-a42c-3288f4e99483	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-09 06:56:07.136985+00	2025-11-08 06:56:07.136986+00
dc8422fc-9b15-4c0f-819a-75ec3bfd1763	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-09 06:57:04.675463+00	2025-11-08 06:57:04.675464+00
56607c94-07f8-419f-bb65-a0720da52c66	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-09 23:23:58.582567+00	2025-11-08 23:23:58.582568+00
b5d336d9-1f67-42fc-8cea-a5799f6da656	77d5ac90-58e3-4257-bc55-f04e417a4601	2025-11-10 13:52:38.876635+00	2025-11-09 13:52:38.876636+00
\.


--
-- Data for Name: student_parents; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.student_parents (id, student_id, parent_id, relationship, is_primary, created_at, updated_at, deleted_at) FROM stdin;
41a63bed-ec56-485d-962b-393b399e0dd3	971ea2dc-c845-4180-950e-3be72dd2ad4b	c23c714f-c948-4dfa-8739-f8ee2a7d8582	father	f	2025-10-25 23:58:38.94181+00	2025-10-25 23:58:38.94181+00	\N
9c4fd29a-a543-4d97-bd72-9dbc898504de	47d4629b-9e16-42fb-9fd3-38602fe1f06d	c23c714f-c948-4dfa-8739-f8ee2a7d8582	father	f	2025-10-28 01:07:32.478587+00	2025-10-28 01:07:32.478587+00	\N
625373fb-44c0-4533-bb8c-5bf1144f8fa1	fe98710d-e6ea-4087-93f5-70acb8731464	4a45a9e3-5989-4960-9f4d-9d07bd64d392	Father	t	2025-10-29 13:12:17.043299+00	2025-10-29 13:12:17.043299+00	\N
4efdfd24-7abd-4a5a-b13b-789d791c716f	15c3c745-2ab1-4ec9-a6cf-8e67ba2ab6e3	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Father	t	2025-10-29 13:13:06.988302+00	2025-10-29 13:13:06.988302+00	\N
982e6c12-73f6-4c16-9247-a387c102c0af	95a7f952-f333-4539-92fe-28529f5d5812	c5953105-0d05-43c5-9cea-287b806232fa	guardian	f	2025-10-29 13:13:36.495403+00	2025-10-29 13:13:36.495403+00	\N
4edbfff7-1edd-4d7f-af31-ef1f9574e558	80362314-ffd8-44a8-a3f7-db382d6b2dd4	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Father	t	2025-10-30 14:11:22.731672+00	2025-10-30 14:11:22.731672+00	\N
4c88dd97-41b4-45c4-87fd-0f3003c1938e	c4c7d5d3-6343-400d-9415-b48d0d51c41a	efdb08db-a413-42ae-884b-fa5a375dd683	Mother	t	2025-10-30 14:12:10.579175+00	2025-10-30 14:12:10.579175+00	\N
c010ac54-09bc-4546-8abb-95cc3c7f4604	8fdbca85-aab8-421a-ab27-328455ce2abf	010e3349-ad39-4049-ba39-77661a15d21f	Guardian	t	2025-10-30 14:12:50.313461+00	2025-10-30 14:12:50.313461+00	\N
f2d3597f-4113-4b23-8b91-64066792c998	781e8926-2293-41e6-80ea-b774fe19847a	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Sister	t	2025-10-30 14:13:46.789468+00	2025-10-30 14:13:46.789468+00	\N
d56744bc-3f9b-4374-a595-37b71d413115	15df728f-b91f-451e-a9a4-12a345c88111	8c0c3dfd-0e58-42ce-b190-1706fb49bbb3	Mother	t	2025-10-30 14:14:11.893295+00	2025-10-30 14:14:11.893295+00	\N
13866352-eb37-4dbb-aa8f-72ae80811791	a30547a2-756c-46c3-8a8b-d34b3f1d2a4f	018b4718-12d4-40fd-9813-b180e462d4ab	Other	t	2025-10-30 14:14:24.273842+00	2025-10-30 14:14:24.273842+00	\N
c2a072b2-47ed-428a-b114-da2a8bf32ed9	a459cf30-855d-45d7-991b-6678073e0da8	3bf3de62-f9cc-40a8-a28a-6d86671386da	Other	t	2025-10-30 14:14:37.321962+00	2025-10-30 14:14:37.321962+00	\N
eb538252-f4fc-4151-8f79-665ff45f5e69	a53eb2c8-733c-49bd-8904-9b267dab9bc6	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Brother	t	2025-10-30 14:15:10.446688+00	2025-10-30 14:15:10.446688+00	\N
95f563f4-4d71-428a-9706-e2f13c6aa551	33dd9669-100d-45ad-a4a6-94b6149f3bb2	4dbf793e-cd98-4829-9bf8-dab48242a9f0	Father	t	2025-10-30 14:15:36.993481+00	2025-10-30 14:15:36.993481+00	\N
b0c56af3-8420-4a38-a007-c9482b11a213	98710d72-7953-418e-9953-c9f92a8a3d6a	efdb08db-a413-42ae-884b-fa5a375dd683	Guardian	t	2025-10-30 14:15:45.512297+00	2025-10-30 14:15:45.512297+00	\N
d9f90a2d-38ec-4c22-9fb7-406bcdfaef9c	7b4215bb-ad96-45e1-b90c-6a9e46486967	8c0c3dfd-0e58-42ce-b190-1706fb49bbb3	Other	t	2025-10-30 14:15:57.353028+00	2025-10-30 14:15:57.353028+00	\N
dba3978b-abd2-4f95-a734-6dc33843694b	7b023803-3775-429c-a6c3-ba81aa3dd244	c59d764e-772e-427d-b739-e81c80b69c02	Mother	t	2025-10-30 14:16:08.363461+00	2025-10-30 14:16:08.363461+00	\N
8c38c0e4-2b48-46d5-9cce-7f883650553a	f530ec17-2e79-47ba-b4d1-b76351c6189f	c59d764e-772e-427d-b739-e81c80b69c02	Guardian	t	2025-10-30 14:16:17.533499+00	2025-10-30 14:16:17.533499+00	\N
b9af9478-769c-48fe-b4c2-d3403d881576	538cfa54-35b5-442f-961c-116e8ca6237e	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Father	t	2025-10-30 14:16:40.793724+00	2025-10-30 14:16:40.793724+00	\N
f7bbdbf0-bfd6-4246-83e8-038d3a72813d	3d7efd16-be7c-4b9b-a832-f4cf79a21e81	3bf3de62-f9cc-40a8-a28a-6d86671386da	Mother	t	2025-10-30 14:17:36.601834+00	2025-10-30 14:17:36.601834+00	\N
fd0c0c78-fbfb-43d0-9e65-6cef13844ff4	a5121591-dfd4-4d01-8d40-16445655b0a0	c9681e39-87da-49a1-b1a9-65e03c7b279e	Father	t	2025-10-30 14:17:58.425504+00	2025-10-30 14:17:58.425504+00	\N
2f0c94a0-59f2-4834-ad72-12e74fc06eec	c36434f1-3c37-4ba0-af1b-7e83e07a03e9	3bf3de62-f9cc-40a8-a28a-6d86671386da	Other	t	2025-10-30 14:18:14.848622+00	2025-10-30 14:18:14.848622+00	\N
31d9b2e6-ffce-434b-9f4d-cb22af82254d	32704121-21f5-4a0a-90f8-97d940e3174c	3bf3de62-f9cc-40a8-a28a-6d86671386da	Brother	t	2025-10-30 14:18:24.945751+00	2025-10-30 14:18:24.945751+00	\N
f7c596a2-e534-4e00-a8ca-45c8a7a0d26f	dfbe2dc2-d32f-40df-bcd2-e12c06974e20	c23c714f-c948-4dfa-8739-f8ee2a7d8582	Father	t	2025-10-30 14:18:38.843844+00	2025-10-30 14:18:38.843844+00	\N
7c829b71-bffd-47f0-92f4-527ee6da5d16	ddd596c0-2882-47cd-ac14-a898efc5a9fe	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Mother	t	2025-10-30 14:18:48.33585+00	2025-10-30 14:18:48.33585+00	\N
7c8419cc-fe0b-47e8-ae08-a50a217e92ee	c3c6c2bc-f4a4-4660-abf9-eedb5ba0a2f5	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Mother	t	2025-10-30 14:19:05.588537+00	2025-10-30 14:19:05.588537+00	\N
1d08dbc7-4e32-4378-ae99-c7aaf0647e0e	c6bac125-9436-45ff-88c3-4d8447c9188c	efdb08db-a413-42ae-884b-fa5a375dd683	Father	t	2025-10-30 14:19:13.965085+00	2025-10-30 14:19:13.965085+00	\N
7cd73d72-257a-463e-8d8f-235c0cf5e0a7	070499b7-86bf-4865-99e2-bbd19afcdc5c	8898bf9c-65c3-46e8-a89a-b82efa4169e9	Father	t	2025-10-30 14:19:23.840602+00	2025-10-30 14:19:23.840602+00	\N
113fe334-a4e3-4b4e-9a6b-987316cb6595	b8228e62-cc47-480a-bef5-8c0730be7e6e	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Father	t	2025-10-30 14:19:33.81168+00	2025-10-30 14:19:33.81168+00	\N
fa11d3d0-e9c4-4ddc-b698-9f2cf5c81374	226f7cc1-54f8-46ed-8f14-adbe2a253287	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Brother	t	2025-10-30 14:19:52.73283+00	2025-10-30 14:19:52.73283+00	\N
c4922e20-2b14-4588-9a54-b53969a550b7	a864f157-a1b3-4e97-aae7-e0bb3f781073	be67f17c-1ab7-432e-9c92-5e17c9f95aa7	Father	t	2025-10-30 14:20:03.102904+00	2025-10-30 14:20:03.102904+00	\N
a76b1558-f724-48f4-bd3d-800a0a2efbad	99171463-5c9d-4b02-ae42-ba4c12a5b697	91d70c56-984a-4ebc-94db-0ea8fad17649	Father	t	2025-10-30 14:20:13.350363+00	2025-10-30 14:20:13.350363+00	\N
3fb83d97-734c-49c5-89ff-5df748fc41c3	62393e02-8dc4-40ae-acd6-9e7aab16f92c	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Mother	t	2025-10-30 14:20:25.280071+00	2025-10-30 14:20:25.280071+00	\N
b6e39399-be42-451a-997f-d9c250fd856a	27618eab-cde9-487d-8adc-4dd1b4563f92	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Father	t	2025-10-30 14:20:36.954089+00	2025-10-30 14:20:36.954089+00	\N
008845f1-0141-42ce-bcaf-4058c64d1232	bfe221a6-9b31-4960-b428-88a0d007cabd	efdb08db-a413-42ae-884b-fa5a375dd683	Father	t	2025-10-30 14:20:48.200171+00	2025-10-30 14:20:48.200171+00	\N
730e2a42-0a97-4634-9faf-f316b0eebd8f	1f5eda38-f94e-4764-8352-878214a0e330	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Father	t	2025-10-30 14:21:07.586818+00	2025-10-30 14:21:07.586818+00	\N
8836503c-63a3-4550-8181-eab6af9dfa46	7fc41845-1a63-450c-9c7d-75807687817e	8c0c3dfd-0e58-42ce-b190-1706fb49bbb3	Brother	t	2025-10-30 14:21:21.534896+00	2025-10-30 14:21:21.534896+00	\N
de8eb4ef-16ac-477d-ac7d-437fbb36e323	67c1327a-807b-4bdf-9ce5-0dbd96a77893	018b4718-12d4-40fd-9813-b180e462d4ab	Sister	t	2025-10-30 14:21:35.83199+00	2025-10-30 14:21:35.83199+00	\N
feb70781-2102-47fe-a7e9-9d12694c50e2	a17bc597-89b9-4f4d-b04d-3974ea58dcaa	c5953105-0d05-43c5-9cea-287b806232fa	Father	t	2025-10-30 14:22:04.539875+00	2025-10-30 14:22:04.539875+00	\N
fd6d2c7c-933f-44ec-b90e-3108b4df5383	1656b9fb-7501-4202-a432-fd103ffff738	be67f17c-1ab7-432e-9c92-5e17c9f95aa7	Father	t	2025-10-30 14:23:14.531462+00	2025-10-30 14:23:14.531462+00	\N
89ca8388-df27-49c0-ab68-5cf6256cca9c	47cee244-132b-4583-a943-487381f0f7fc	1acf82c7-baf7-43c5-956f-814a767c39b6	Mother	t	2025-10-30 14:23:40.891658+00	2025-10-30 14:23:40.891658+00	\N
d30253b5-31a4-46c8-a048-cef59c437715	1c712007-8146-4c58-b5b5-25e87dca6c2c	f8235b4d-9f51-4297-9225-1ec363ee1804	Father	t	2025-10-30 14:23:51.380713+00	2025-10-30 14:23:51.380713+00	\N
d6bab98a-afd0-4065-adb0-4e44cc2b4880	ccd343b5-2073-4c58-a146-25c56d4432f8	c23c714f-c948-4dfa-8739-f8ee2a7d8582	Mother	t	2025-10-30 14:24:06.078992+00	2025-10-30 14:24:06.078992+00	\N
11b85c40-bd16-4679-a7cf-a14226c2b029	3eea8f16-876e-4b45-8e2a-1d079c7f5b16	4a45a9e3-5989-4960-9f4d-9d07bd64d392	Father	t	2025-10-30 14:24:23.507616+00	2025-10-30 14:24:23.507616+00	\N
6136d63c-1c17-4cec-9945-10166eb35175	0474cd89-af32-4217-a78c-726e8c802e58	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Father	t	2025-10-30 14:24:36.087814+00	2025-10-30 14:24:36.087814+00	\N
8981705f-00ed-4edf-a89f-ad61e5b56f61	84343b8b-4771-45b6-9190-4ebf01c16561	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Father	t	2025-10-30 14:24:48.8545+00	2025-10-30 14:24:48.8545+00	\N
22b4497a-a750-4e80-baae-6161717d7179	4ed32733-8072-43b1-afcc-1e064cd1e9b9	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Father	t	2025-10-30 14:24:58.129177+00	2025-10-30 14:24:58.129177+00	\N
4d316778-76fc-4044-b080-5ac07c3c2fe2	76852c84-a03b-4b35-b638-ccbe7d9717a1	a913fdaa-c9d8-444f-8cc0-4ddb845a67c7	Guardian	t	2025-10-30 14:25:15.789867+00	2025-10-30 14:25:15.789867+00	\N
c596ce71-2d92-4278-b25a-c05f2cde4b04	477d462a-6165-4d11-a46d-a43d1b9c7768	8898bf9c-65c3-46e8-a89a-b82efa4169e9	Father	t	2025-10-30 14:25:36.49793+00	2025-10-30 14:25:36.49793+00	\N
7f202ef8-4e19-4d34-9d19-0a303f2fdc3f	b40c48db-adc2-4c9f-abb5-42cd86f127fe	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Father	t	2025-10-30 14:25:58.880454+00	2025-10-30 14:25:58.880454+00	\N
202d89d6-9b63-40c6-975b-794f918f8ad6	a6cfe41d-2548-44ba-a4ae-be716478da09	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Father	t	2025-10-30 14:26:32.784042+00	2025-10-30 14:26:32.784042+00	\N
43e325b2-951a-48a7-b0ff-fb4e98822500	856a1929-b3e2-46a8-86b2-e97dc46935fa	91d70c56-984a-4ebc-94db-0ea8fad17649	Father	t	2025-10-30 14:27:29.777608+00	2025-10-30 14:27:29.777608+00	\N
2e5cfb4b-b0d6-4bf3-826d-1fc1e005820e	ee79cdd6-5fdc-41f3-9c7e-493501913253	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Father	t	2025-10-30 14:27:40.151075+00	2025-10-30 14:27:40.151075+00	\N
c03580a0-9ea5-46a1-abb4-0377c36bbcdd	ff56db77-04e3-4e9b-8d10-49ab82582233	8c0c3dfd-0e58-42ce-b190-1706fb49bbb3	Father	t	2025-10-30 14:27:52.32501+00	2025-10-30 14:27:52.32501+00	\N
c21cb9a3-7a5d-4fb0-86c6-bb14b914c5fe	af6fcd68-fe50-4e9f-91a6-c99f492e8593	3bf3de62-f9cc-40a8-a28a-6d86671386da	Father	t	2025-10-30 14:28:03.923289+00	2025-10-30 14:28:03.923289+00	\N
0d905e17-bc59-49cd-ade0-edb126ceaeb2	6119fe1d-14f2-478b-934e-0034af52c647	efdb08db-a413-42ae-884b-fa5a375dd683	Father	t	2025-10-30 14:28:22.018615+00	2025-10-30 14:28:22.018615+00	\N
c7be3b13-a2fa-4b49-beff-16836d1c802c	ce955be9-8dc3-492c-b0f2-b63d6722d8cf	c9681e39-87da-49a1-b1a9-65e03c7b279e	Father	t	2025-10-30 14:29:12.564743+00	2025-10-30 14:29:12.564743+00	\N
f5b5d07e-8bb3-44b9-91de-1903eea553de	fa83f8fa-5a6a-401d-947f-45817a147bda	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Mother	t	2025-10-30 14:29:29.105668+00	2025-10-30 14:29:29.105668+00	\N
a263b21f-77ee-4b66-84f7-86f4560a6478	e69583bf-4703-43c2-b307-f6bd4d1367ae	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Guardian	t	2025-10-30 14:33:02.372151+00	2025-10-30 14:33:02.372151+00	\N
55760c86-8f3c-42ba-afde-a2e4a8d7bf24	04bb7f00-16bf-4d29-887f-1fd2c431a239	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Mother	t	2025-10-30 14:34:06.298114+00	2025-10-30 14:34:06.298114+00	\N
3dccb412-4d4e-4f66-ad97-75daaff21f5a	c22a1051-b083-4380-a45f-6412fdcddd50	1acf82c7-baf7-43c5-956f-814a767c39b6	Father	t	2025-10-30 14:35:16.437113+00	2025-10-30 14:35:16.437113+00	\N
66a68c48-8b92-4998-84df-ea3f670747c2	69ca057d-4216-4b11-b5d6-2d934f0c3cb2	c9681e39-87da-49a1-b1a9-65e03c7b279e	Other	t	2025-10-30 14:35:25.747123+00	2025-10-30 14:35:25.747123+00	\N
2e5e8a2f-241f-43ee-8201-df953dbdca1d	775c41ff-60a0-4794-b74d-e4632b21817c	91d70c56-984a-4ebc-94db-0ea8fad17649	Father	t	2025-10-30 14:35:34.988212+00	2025-10-30 14:35:34.988212+00	\N
e60dc9e3-1d1f-4d9d-8f55-819de359ceb9	6e00b41e-a6f3-4260-8330-447fab010c93	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Father	t	2025-10-30 14:35:45.136039+00	2025-10-30 14:35:45.136039+00	\N
6fccad80-f95e-45fc-bbc2-709127e10636	72e0ed04-9a87-4214-a0c3-ec46b4519db2	018b4718-12d4-40fd-9813-b180e462d4ab	Father	t	2025-10-30 14:36:24.979471+00	2025-10-30 14:36:24.979471+00	\N
21c835c6-f0e6-4d04-b4ed-d336f4ba26c3	40ca9bbb-5afd-4ab6-bf7e-898b546b89eb	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Sister	t	2025-10-30 14:45:52.780865+00	2025-10-30 14:45:52.780865+00	\N
d9c9f21a-db05-4854-9965-d9746f2b2c48	4b2b5703-7ba4-4afc-8541-711ded89d878	4dbf793e-cd98-4829-9bf8-dab48242a9f0	Mother	t	2025-10-30 14:46:22.788456+00	2025-10-30 14:46:22.788456+00	\N
24a35fcb-b3e9-4a05-844f-7fb88d3a0320	18bc33ae-d99a-41f3-ad90-e8c80acd954b	8898bf9c-65c3-46e8-a89a-b82efa4169e9	Brother	t	2025-10-30 14:46:27.617026+00	2025-10-30 14:46:27.617026+00	\N
e2cad26c-3309-44f4-9758-981fd4187ae7	10975f77-cf5f-4b8e-81c6-8017c72360e1	c59d764e-772e-427d-b739-e81c80b69c02	Other	t	2025-10-30 14:46:31.429983+00	2025-10-30 14:46:31.429983+00	\N
48e1f39f-9fe8-4c0b-addb-f57b76bda19d	f442262a-0ef7-4bdd-8909-e8e81459b56a	f8235b4d-9f51-4297-9225-1ec363ee1804	Guardian	t	2025-10-30 14:46:35.51098+00	2025-10-30 14:46:35.51098+00	\N
b84636fc-e4b9-4105-b2dc-80c2aa000166	a207afc8-ddd6-4cd5-b5c7-c1d83732fdd3	f8235b4d-9f51-4297-9225-1ec363ee1804	Other	t	2025-10-30 14:46:39.724563+00	2025-10-30 14:46:39.724563+00	\N
8a5bfd55-58f3-4784-8fd9-fa25149cf75f	f31c5114-12cc-4e2e-b3bd-cd0b6c9c16cb	c23c714f-c948-4dfa-8739-f8ee2a7d8582	Other	t	2025-10-30 14:46:42.692011+00	2025-10-30 14:46:42.692011+00	\N
63c04c04-f08a-4e7f-9606-cb3583fea159	5d94e046-0fcd-4b33-a5b0-070c020d349a	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Brother	t	2025-10-30 14:46:45.853037+00	2025-10-30 14:46:45.853037+00	\N
56eaaff7-0afc-4c0e-80fc-260b704c4640	cd4ed8bd-ddfc-4be9-ad1f-278573f9c06a	1acf82c7-baf7-43c5-956f-814a767c39b6	Brother	t	2025-10-30 14:46:49.371058+00	2025-10-30 14:46:49.371058+00	\N
3e4d9d96-e240-40a2-b69b-6084e42b8481	700459ce-314b-4421-9d3a-27acc98a38da	c23c714f-c948-4dfa-8739-f8ee2a7d8582	Sister	t	2025-10-30 14:46:53.840578+00	2025-10-30 14:46:53.840578+00	\N
3c052022-f09b-4bbf-9b56-d645978e60c1	8ba9b42c-da18-420b-b60d-3d482cf217bd	010e3349-ad39-4049-ba39-77661a15d21f	Sister	t	2025-10-30 14:46:57.219556+00	2025-10-30 14:46:57.219556+00	\N
afdfda70-87ad-432d-8da3-fcc39bad57ac	6b733a50-ad7b-4252-ba91-8016313dc00f	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Father	t	2025-10-30 14:47:01.942086+00	2025-10-30 14:47:01.942086+00	\N
bc785756-59c8-499e-8b25-41b0c934d826	7736a653-8173-4402-bac8-c68aea842766	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Father	t	2025-10-30 14:47:05.386639+00	2025-10-30 14:47:05.386639+00	\N
261000f0-8d94-4828-883e-04563af81cff	2e20598f-607f-415d-a273-389d6ee1a8de	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Other	t	2025-10-30 14:47:08.295585+00	2025-10-30 14:47:08.295585+00	\N
a40addd4-24cd-494e-85cd-0d317cd9a591	c2faa1b0-2b9b-438c-979f-45e6774e385b	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Other	t	2025-10-30 14:47:37.702152+00	2025-10-30 14:47:37.702152+00	\N
6baecb88-0e25-4838-b321-f0db78f6dae4	66ff9037-2a53-40cd-b6e3-27bbb2fdb9d9	4a45a9e3-5989-4960-9f4d-9d07bd64d392	Mother	t	2025-10-30 14:47:41.733696+00	2025-10-30 14:47:41.733696+00	\N
1bd090bd-7834-4adf-9ab8-3ccbc030eed6	777155cb-b6ce-49fd-8e69-a23a0a036816	010e3349-ad39-4049-ba39-77661a15d21f	Brother	t	2025-10-30 14:47:45.559506+00	2025-10-30 14:47:45.559506+00	\N
909f04ad-9af8-4b81-b492-51988f9adb55	6aad2a83-6b17-4e8e-961a-fab1d31103c1	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Sister	t	2025-10-30 14:47:49.427268+00	2025-10-30 14:47:49.427268+00	\N
83d8dba4-cb9c-4648-ac5b-a50eed6d697e	51d870b7-24b5-4aa5-ac7a-c8b651241072	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Mother	t	2025-10-30 14:47:54.610282+00	2025-10-30 14:47:54.610282+00	\N
415faa60-96fb-499d-b75a-9d350cb621f7	d0170f13-040f-4e0a-b39d-38f9b9cdd8e7	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Father	t	2025-10-30 14:48:01.856263+00	2025-10-30 14:48:01.856263+00	\N
a3873700-9944-4fee-90e9-162b8810ba83	bdf10862-c484-4ccd-8306-d79ac1e1c9ed	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Brother	t	2025-10-30 14:49:32.780962+00	2025-10-30 14:49:32.780962+00	\N
c520552c-1079-49e7-b810-d75b07b5cafc	32e57d76-f679-4115-a5d0-85ff2cbddfac	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Brother	t	2025-10-30 14:49:36.443347+00	2025-10-30 14:49:36.443347+00	\N
9881538a-5fd2-447f-87e8-a12683375717	0061740c-ae81-4b3e-a49c-0f65f5ca2c45	91d70c56-984a-4ebc-94db-0ea8fad17649	Father	t	2025-10-30 14:49:38.837464+00	2025-10-30 14:49:38.837464+00	\N
70cc1618-ddab-4d93-b5a9-7cd3b89fa9d8	9e712caf-feca-4516-83c1-e936b6978be8	efdb08db-a413-42ae-884b-fa5a375dd683	Brother	t	2025-10-30 14:49:49.128061+00	2025-10-30 14:49:49.128061+00	\N
ec14cab8-6cda-4941-a709-cad41fbf4e8c	2c6d0982-1a79-4cff-ab58-7c7eb1a13bfb	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Other	t	2025-10-30 14:49:52.834056+00	2025-10-30 14:49:52.834056+00	\N
f095b2b3-01a8-4a8e-96ab-9a2cc93b2699	c8befd5a-6c1c-4f29-b882-1a1680b97b14	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Father	t	2025-10-30 14:49:54.966145+00	2025-10-30 14:49:54.966145+00	\N
2b3f8cc2-7a18-4258-84c8-405dbb6919a6	5cc81719-9bae-43b8-9eb5-9f15293fca61	c59d764e-772e-427d-b739-e81c80b69c02	Guardian	t	2025-10-30 14:49:57.400057+00	2025-10-30 14:49:57.400057+00	\N
ed29d05d-45b2-4bfa-b327-dc4e3609ec50	3425274f-c668-415d-95d1-9717841fa2a9	4a45a9e3-5989-4960-9f4d-9d07bd64d392	Sister	t	2025-10-30 14:49:59.875212+00	2025-10-30 14:49:59.875212+00	\N
ed44a2f3-6851-417f-bc38-0609d6072270	048c3c31-24db-457b-8b91-422d6e6df08f	c23c714f-c948-4dfa-8739-f8ee2a7d8582	Brother	t	2025-10-30 14:50:03.987579+00	2025-10-30 14:50:03.987579+00	\N
3236a03e-c398-4db3-8fc4-5f9f12f764ea	94dac129-6f43-489a-998b-a5bf713bc534	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Guardian	t	2025-10-30 14:50:06.549083+00	2025-10-30 14:50:06.549083+00	\N
5acf18f6-c640-4d53-999b-9419373beebc	6b3390f7-c22a-49fa-a9c0-8c4820c254ce	1acf82c7-baf7-43c5-956f-814a767c39b6	Mother	t	2025-10-30 14:50:09.309601+00	2025-10-30 14:50:09.309601+00	\N
18b159a3-d175-4156-9af6-192cb07f9992	7ade8215-2538-48b5-8a36-0fa7d2e8462c	4a45a9e3-5989-4960-9f4d-9d07bd64d392	Other	t	2025-10-30 14:50:58.816252+00	2025-10-30 14:50:58.816252+00	\N
31fab76c-7a47-4ecd-b589-85e560b399e0	0590e0cd-307d-48ea-8661-c435e75287f7	c59d764e-772e-427d-b739-e81c80b69c02	Mother	t	2025-10-30 14:51:01.939692+00	2025-10-30 14:51:01.939692+00	\N
a0ff310f-327e-4314-ae25-30741f46b29b	bfa9bd79-be0a-410d-b9e9-2dae995167c0	010e3349-ad39-4049-ba39-77661a15d21f	Mother	t	2025-10-30 14:51:04.228714+00	2025-10-30 14:51:04.228714+00	\N
70a9dc5b-58ed-40b6-883a-f0d138fe8d9b	35ae3165-7941-4cbe-bb6b-e7ac996447b4	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Brother	t	2025-10-30 14:51:07.376803+00	2025-10-30 14:51:07.376803+00	\N
46820f7b-b55a-45f5-aac2-9f7c99e9764d	c04fc369-217a-42af-a946-7de7c759c977	be67f17c-1ab7-432e-9c92-5e17c9f95aa7	Brother	t	2025-10-30 14:51:10.021286+00	2025-10-30 14:51:10.021286+00	\N
962c738a-0471-4d9b-99b2-8047a6e850e3	981438b1-e7a1-4cd2-9c98-7af333e41167	018b4718-12d4-40fd-9813-b180e462d4ab	Father	t	2025-10-30 14:51:13.08171+00	2025-10-30 14:51:13.08171+00	\N
d365db18-297c-4094-98cf-3fef30f7ca0e	187fc776-2ce7-4e27-bd6b-4668a7e375c6	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Mother	t	2025-10-30 14:51:15.765491+00	2025-10-30 14:51:15.765491+00	\N
d83d957a-242c-45e8-8b1a-36f6a65acf39	049aa48f-1c19-4785-a5e1-517875e46acc	4dbf793e-cd98-4829-9bf8-dab48242a9f0	Sister	t	2025-10-30 14:51:17.824781+00	2025-10-30 14:51:17.824781+00	\N
c40e366b-1402-4f86-8807-dfa13bffcf28	5c500668-c7a2-4413-8db1-dd52e686b74c	8898bf9c-65c3-46e8-a89a-b82efa4169e9	Mother	t	2025-10-30 14:51:22.25202+00	2025-10-30 14:51:22.25202+00	\N
038e1584-6f46-413b-8c08-f902fe1baaca	b9212c08-d93c-4363-ad98-152e7b2a6057	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Father	t	2025-10-30 14:51:30.943623+00	2025-10-30 14:51:30.943623+00	\N
59387656-9638-4443-a4e4-09ff4189516a	66d242ae-f1a0-4aee-ade4-0f24b6be0b33	3bf3de62-f9cc-40a8-a28a-6d86671386da	Mother	t	2025-10-30 14:52:08.355638+00	2025-10-30 14:52:08.355638+00	\N
9ac6531d-35fe-43d9-80f9-78aec9624afc	2b0e6567-dfcd-4cfa-ac68-867126d9afdf	91d70c56-984a-4ebc-94db-0ea8fad17649	Mother	t	2025-10-30 14:52:11.042183+00	2025-10-30 14:52:11.042183+00	\N
6a6e74f7-7059-428d-ae24-093fdf02e85a	1d376eb2-0065-4926-9139-3a0fb011a854	c23c714f-c948-4dfa-8739-f8ee2a7d8582	Father	t	2025-10-30 14:52:13.70515+00	2025-10-30 14:52:13.70515+00	\N
b0ff4e98-9e0a-476c-bcfe-c2994c767c3f	d1c77b5e-ebda-473b-a8f7-7c7614e8b074	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Sister	t	2025-10-30 14:52:15.693879+00	2025-10-30 14:52:15.693879+00	\N
57b0cc89-b02d-4847-892c-349c2b1a30e0	d40a1996-7f67-4463-b294-88f25ccbaa05	c9681e39-87da-49a1-b1a9-65e03c7b279e	Mother	t	2025-10-30 14:52:20.320656+00	2025-10-30 14:52:20.320656+00	\N
539117f4-22c2-40ad-a505-a73ee69aafa5	84639900-5e24-46b4-b8f2-10b4ea262cf8	1acf82c7-baf7-43c5-956f-814a767c39b6	Sister	t	2025-10-30 14:52:25.035187+00	2025-10-30 14:52:25.035187+00	\N
232bac5b-ca6b-4e1f-8b90-7603a91d140f	9956784e-aaa5-4737-a8e8-ab1fc81a324d	c59d764e-772e-427d-b739-e81c80b69c02	Mother	t	2025-10-30 14:52:27.875216+00	2025-10-30 14:52:27.875216+00	\N
335fa68c-59b6-4c71-815f-0fb24d06e587	a9a17332-6455-498a-9f5d-d469a660407b	c59d764e-772e-427d-b739-e81c80b69c02	Sister	t	2025-10-30 14:52:30.517663+00	2025-10-30 14:52:30.517663+00	\N
231b172d-dc8b-47b3-ae2c-5e1280d514b8	7f5fcc52-1981-4155-8b59-b45e624e44e5	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Sister	t	2025-10-30 14:52:35.444786+00	2025-10-30 14:52:35.444786+00	\N
ff262eaf-bc3d-4dc1-94f0-167139b059b3	8b6fd685-eff1-4ba1-9a8e-776e8b4f335f	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Brother	t	2025-10-30 14:52:39.954268+00	2025-10-30 14:52:39.954268+00	\N
c8050c72-51ee-4ff3-82b3-d7bb4f4a1b4b	cba874c0-472a-481c-b203-1f8beb00fec4	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Guardian	t	2025-10-30 14:52:43.175939+00	2025-10-30 14:52:43.175939+00	\N
530cf7d5-5a15-446c-9898-f84c528dbd2b	95ed9be6-69b1-40df-b908-a73a97a4582d	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Sister	t	2025-10-30 14:52:46.422189+00	2025-10-30 14:52:46.422189+00	\N
e3529ab4-e87c-4440-a1ca-a4a2aba93e19	218a40cf-62c1-4fe2-9bfe-c8a4b236b639	1acf82c7-baf7-43c5-956f-814a767c39b6	Sister	t	2025-10-30 14:52:48.721686+00	2025-10-30 14:52:48.721686+00	\N
ceeff732-331d-42c6-83b5-bb67f8a958ef	b6fc5e1b-91df-4818-a57c-2cb4d2990080	8c0c3dfd-0e58-42ce-b190-1706fb49bbb3	Mother	t	2025-10-30 14:52:51.251728+00	2025-10-30 14:52:51.251728+00	\N
0749e6ba-dcfa-4f65-981d-e9a526ad17f0	c7cfdfb6-9b58-4d6b-8c81-742aa3559012	c5953105-0d05-43c5-9cea-287b806232fa	Mother	t	2025-10-30 14:52:53.3217+00	2025-10-30 14:52:53.3217+00	\N
03bf7a13-4b57-4bdd-9511-aed58528faa5	10b3d287-212b-414c-b980-f86c5dbf9379	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Guardian	t	2025-10-30 14:52:54.956239+00	2025-10-30 14:52:54.956239+00	\N
b55ddda8-44b5-482d-9edf-45f8b67a839c	74eb0d9d-36ce-49bb-9879-3b655071ed5d	1acf82c7-baf7-43c5-956f-814a767c39b6	Sister	t	2025-10-30 14:52:57.174236+00	2025-10-30 14:52:57.174236+00	\N
1412a348-ef96-49bf-a873-77d67fa225c4	eb334d6f-c2ad-4e75-b13e-bebc0a881caa	c59d764e-772e-427d-b739-e81c80b69c02	Other	t	2025-10-30 14:52:58.792197+00	2025-10-30 14:52:58.792197+00	\N
eb0f258a-a8eb-4555-8dfa-707d0e081ea9	255f0a69-958b-44db-9d26-4e6ef5e0539e	010e3349-ad39-4049-ba39-77661a15d21f	Brother	t	2025-10-30 14:53:00.944247+00	2025-10-30 14:53:00.944247+00	\N
ccfc2cc7-19f3-4a0b-879c-8ac9f3b16399	6212077c-a2e2-4258-be34-44152e6738f3	b77b0558-2a2c-4ead-afe0-00f473eaa9d7	Other	t	2025-10-30 14:53:02.555265+00	2025-10-30 14:53:02.555265+00	\N
dc2e9341-f6f8-4ec6-b34b-9e3eec2e7239	91a6ad2c-fd24-4022-b6b6-d82f0049f24c	be67f17c-1ab7-432e-9c92-5e17c9f95aa7	Sister	t	2025-10-30 14:53:04.164754+00	2025-10-30 14:53:04.164754+00	\N
cadddef2-b414-41dc-ad5c-9aec4dd79780	560d3407-6354-43fe-9d00-0c7c3cdb6a27	260ec7d5-49c2-4ff4-8ec5-7240b7749636	Sister	t	2025-10-30 14:53:05.779773+00	2025-10-30 14:53:05.779773+00	\N
78182d56-6817-4007-9b90-060bf84afbea	87d56066-a631-4e5c-beb6-2213a05b04d6	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Other	t	2025-10-30 14:53:10.042234+00	2025-10-30 14:53:10.042234+00	\N
dcbaaa57-5e91-4b78-8a21-0c28ba89e31b	db17bf48-4d11-4231-814b-8420148478f8	3bf3de62-f9cc-40a8-a28a-6d86671386da	Mother	t	2025-10-30 14:53:12.22125+00	2025-10-30 14:53:12.22125+00	\N
9d9eb96b-c409-4e69-bd5a-49414a404cac	f4929bfa-749c-40bc-a366-900c0adf608b	825fc6bc-02e0-4a52-8179-c0922ab8bdd4	Father	t	2025-10-30 14:53:13.941713+00	2025-10-30 14:53:13.941713+00	\N
bf468dd9-76d8-43b4-8f0d-d40af17ca930	9d2401a0-e15d-4d46-a23e-144c6916701c	d508f392-39ca-42ab-982a-1d6f6bb2f73c	Guardian	t	2025-10-30 14:53:16.042265+00	2025-10-30 14:53:16.042265+00	\N
63d4b584-3e1d-49fb-952f-4fc30fa1029e	c8125e9f-cf06-4561-bec7-9b534ebe36b4	be67f17c-1ab7-432e-9c92-5e17c9f95aa7	Other	t	2025-10-30 14:53:18.376772+00	2025-10-30 14:53:18.376772+00	\N
1ff43bf9-7b00-47b1-bdbb-02c030d5152f	5a422dfc-0f4a-4815-9126-7d73938c04e8	010e3349-ad39-4049-ba39-77661a15d21f	Sister	t	2025-10-30 14:53:45.824834+00	2025-10-30 14:53:45.824834+00	\N
e2dac43e-3fe7-4d71-8900-019a56075bfd	12d6d4fd-c53c-4741-b621-3e073836c3fc	1acf82c7-baf7-43c5-956f-814a767c39b6	Mother	t	2025-10-30 14:54:39.940365+00	2025-10-30 14:54:39.940365+00	\N
92fa2249-0d0f-4a48-9a66-67fb5375e1ee	caea02af-b453-43d5-aec8-fc1271477c5b	8898bf9c-65c3-46e8-a89a-b82efa4169e9	Mother	t	2025-10-30 14:54:54.388554+00	2025-10-30 14:54:54.388554+00	\N
df1bf917-23e8-4857-9e47-c5c7d44692ee	459c9b34-7bb8-42a1-9b94-27f325f8c1ff	fda3dfc7-ab81-4cfa-bcc1-6a4e119fc216	Sister	t	2025-10-30 14:54:57.184544+00	2025-10-30 14:54:57.184544+00	\N
1db08099-2aae-44fb-b3c7-e79901ca64ae	f3319a75-81cd-423c-b35e-61defea2512f	010e3349-ad39-4049-ba39-77661a15d21f	Other	t	2025-10-30 14:55:05.642087+00	2025-10-30 14:55:05.642087+00	\N
16de3ae4-11a1-4b53-90dd-edc9e97be888	8e0dd30a-349a-4b7c-8cf0-452b213bf9d7	4dbf793e-cd98-4829-9bf8-dab48242a9f0	Sister	t	2025-10-30 14:55:07.585943+00	2025-10-30 14:55:07.585943+00	\N
7bfbc251-1093-4bb0-93cf-f2eb65c7bbec	b7946e2d-aa2a-47e9-ac0b-138fb648b6db	c59d764e-772e-427d-b739-e81c80b69c02	Brother	t	2025-10-30 14:55:09.789066+00	2025-10-30 14:55:09.789066+00	\N
3a117e73-de4b-4a06-9111-8af781a6efb0	c7cbee27-6332-4e0e-b239-811b7e84c21d	e7a35468-f724-46ad-8dfc-6d3f4ff4da1d	Guardian	t	2025-10-30 14:55:11.420589+00	2025-10-30 14:55:11.420589+00	\N
ba6f9287-8775-4bf4-be57-126739f58236	11f8d9a6-3d9b-4803-b98c-e1579720e0b7	91d70c56-984a-4ebc-94db-0ea8fad17649	Father	t	2025-10-30 14:55:13.602143+00	2025-10-30 14:55:13.602143+00	\N
3122b327-7294-4d18-81f6-a058099ed6ef	da450125-228f-4d07-baf2-35099b138251	c59d764e-772e-427d-b739-e81c80b69c02	Other	t	2025-10-30 14:55:17.256188+00	2025-10-30 14:55:17.256188+00	\N
7c9274af-b865-4bf8-93c5-ad7014e5f8d7	e029a019-d0a8-4203-83f8-fead6f15a9e8	efdb08db-a413-42ae-884b-fa5a375dd683	Father	t	2025-10-30 14:58:52.453793+00	2025-10-30 14:58:52.453793+00	\N
d4d8ae47-a8f9-4c5b-8315-7b867d4c60ad	8f8e3893-ad14-44cd-acfc-d5feb1a9e762	c9681e39-87da-49a1-b1a9-65e03c7b279e	Father	t	2025-10-30 14:59:48.077594+00	2025-10-30 14:59:48.077594+00	\N
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.students (id, student_id, first_name, last_name, date_of_birth, gender, address, class_id, is_active, created_at, updated_at, deleted_at) FROM stdin;
47cee244-132b-4583-a943-487381f0f7fc	STU-2025-041	Maureen	Vaughn	2008-11-27	female	74672 Harmon Fords, Bryanberg, AZ 59400	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:23:40.891658	2025-10-30 14:23:40.891658	\N
971ea2dc-c845-4180-950e-3be72dd2ad4b	STU-2025-001	Imaad	Muniir	2001-06-06	male	kampala	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-23 20:27:51.115641	2025-10-25 23:58:38.937672	\N
47d4629b-9e16-42fb-9fd3-38602fe1f06d	STU-2025-002	Wandela	Akram	2013-01-31	male	salaama	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-25 23:57:38.525012	2025-10-28 01:07:32.319979	\N
fe98710d-e6ea-4087-93f5-70acb8731464	STU-2025-004	Raymond	Johnson	2017-12-30	male	Unit 3928 Box 0717, DPO AA 29481	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-29 13:12:17.043299	2025-10-29 13:12:17.043299	\N
15c3c745-2ab1-4ec9-a6cf-8e67ba2ab6e3	STU-2025-005	Kimberly	Hamilton	2018-06-02	female	312 Miller Union, Lisaton, GA 82309	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-29 13:13:06.988302	2025-10-29 13:13:06.988302	\N
95a7f952-f333-4539-92fe-28529f5d5812	STU-2025-003	Joseph	Carey	2017-01-30	female	29189 Clark Tunnel Suite 477, Simpsonland, ME 78815	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-29 13:07:11.280133	2025-10-29 13:13:36.487633	\N
80362314-ffd8-44a8-a3f7-db382d6b2dd4	STU-2025-006	Laura	Valencia	2013-10-20	male	7837 Joshua Route Suite 042, Harringtonfurt, RI 83707	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:11:22.731672	2025-10-30 14:11:22.731672	\N
c4c7d5d3-6343-400d-9415-b48d0d51c41a	STU-2025-007	Cody	Sims	2016-01-21	female	295 Jacqueline Summit Apt. 243, Port Michael, NJ 70807	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:12:10.579175	2025-10-30 14:12:10.579175	\N
8fdbca85-aab8-421a-ab27-328455ce2abf	STU-2025-008	David	Smith	2010-04-01	male	585 Dickson Wells Apt. 329, East Dean, ID 29966	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:12:50.313461	2025-10-30 14:12:50.313461	\N
781e8926-2293-41e6-80ea-b774fe19847a	STU-2025-009	Donald	Powell	2017-04-02	male	8013 Johnson Course Apt. 641, Ramosmouth, MP 34329	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:13:46.789468	2025-10-30 14:13:46.789468	\N
15df728f-b91f-451e-a9a4-12a345c88111	STU-2025-010	Charles	Smith	2008-07-18	male	05912 Gonzalez Flat Apt. 034, Robertfort, FL 31468	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:14:11.893295	2025-10-30 14:14:11.893295	\N
a30547a2-756c-46c3-8a8b-d34b3f1d2a4f	STU-2025-011	Jennifer	Ramirez	2014-07-27	female	9769 Derrick Groves Suite 628, North Roy, AZ 05793	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:14:24.273842	2025-10-30 14:14:24.273842	\N
a459cf30-855d-45d7-991b-6678073e0da8	STU-2025-012	Sean	Willis	2017-02-08	male	055 Brown Lock Suite 278, Tracymouth, AK 45257	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:14:37.321962	2025-10-30 14:14:37.321962	\N
a53eb2c8-733c-49bd-8904-9b267dab9bc6	STU-2025-013	Anthony	Marquez	2019-02-20	male	USS Turner, FPO AP 94475	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:15:10.446688	2025-10-30 14:15:10.446688	\N
33dd9669-100d-45ad-a4a6-94b6149f3bb2	STU-2025-014	Alicia	Medina	2007-11-05	female	44972 Diaz Plains, Turnerborough, MA 91531	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:15:36.993481	2025-10-30 14:15:36.993481	\N
98710d72-7953-418e-9953-c9f92a8a3d6a	STU-2025-015	Zachary	Rivas	2016-10-16	female	988 David Mills, Villarrealstad, IL 20026	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:15:45.512297	2025-10-30 14:15:45.512297	\N
7b4215bb-ad96-45e1-b90c-6a9e46486967	STU-2025-016	Stephanie	Reeves	2015-11-20	male	37602 Martinez Station, Gomezbury, AL 64187	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:15:57.353028	2025-10-30 14:15:57.353028	\N
7b023803-3775-429c-a6c3-ba81aa3dd244	STU-2025-017	Patrick	Kline	2019-01-27	female	85004 Henry Rest Suite 835, Robertland, AZ 58967	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:16:08.363461	2025-10-30 14:16:08.363461	\N
f530ec17-2e79-47ba-b4d1-b76351c6189f	STU-2025-018	Jodi	Miller	2008-08-06	male	2049 Diane Track, Scottberg, CA 52275	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:16:17.533499	2025-10-30 14:16:17.533499	\N
538cfa54-35b5-442f-961c-116e8ca6237e	STU-2025-019	Mario	Humphrey	2013-11-09	male	239 Susan Forges, Conleymouth, VA 30327	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:16:40.793724	2025-10-30 14:16:40.793724	\N
3d7efd16-be7c-4b9b-a832-f4cf79a21e81	STU-2025-020	James	Shepherd	2006-12-26	male	92694 Young Plaza Apt. 131, Medinafurt, WI 36947	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:17:36.601834	2025-10-30 14:17:36.601834	\N
a5121591-dfd4-4d01-8d40-16445655b0a0	STU-2025-021	Angel	Benson	2011-09-06	male	3179 Watson Locks Apt. 434, New Denisemouth, VI 59533	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:17:58.425504	2025-10-30 14:17:58.425504	\N
c36434f1-3c37-4ba0-af1b-7e83e07a03e9	STU-2025-022	Leslie	Holden	2012-11-30	male	6571 Thomas Pike Suite 119, New George, NE 54693	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:18:14.848622	2025-10-30 14:18:14.848622	\N
32704121-21f5-4a0a-90f8-97d940e3174c	STU-2025-023	John	Morris	2016-02-04	male	95306 Powell Street, Brianfort, CA 37275	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:18:24.945751	2025-10-30 14:18:24.945751	\N
dfbe2dc2-d32f-40df-bcd2-e12c06974e20	STU-2025-024	Jose	Carpenter	2016-10-17	male	469 Johnston Path, Schmidtville, ID 34188	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:18:38.843844	2025-10-30 14:18:38.843844	\N
ddd596c0-2882-47cd-ac14-a898efc5a9fe	STU-2025-025	Cynthia	Taylor	2010-02-16	male	3017 Samuel Ports, South Samuel, WI 43492	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:18:48.33585	2025-10-30 14:18:48.33585	\N
c3c6c2bc-f4a4-4660-abf9-eedb5ba0a2f5	STU-2025-026	Andre	Hawkins	2017-02-14	male	6465 Wade Ridges Apt. 720, Lake Ashley, AS 72504	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:19:05.588537	2025-10-30 14:19:05.588537	\N
c6bac125-9436-45ff-88c3-4d8447c9188c	STU-2025-027	James	Willis	2016-05-07	male	656 Gloria Street, South Marktown, IA 58471	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:19:13.965085	2025-10-30 14:19:13.965085	\N
070499b7-86bf-4865-99e2-bbd19afcdc5c	STU-2025-028	Ryan	Fuller	2019-05-10	female	659 Gonzalez Points, North Patrickchester, MH 82405	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:19:23.840602	2025-10-30 14:19:23.840602	\N
b8228e62-cc47-480a-bef5-8c0730be7e6e	STU-2025-029	Jacob	Nguyen	2017-08-05	male	8999 Mathews Points, South Christopher, IN 80773	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:19:33.81168	2025-10-30 14:19:33.81168	\N
226f7cc1-54f8-46ed-8f14-adbe2a253287	STU-2025-030	Carolyn	Poole	2010-08-12	female	74758 Harvey Meadow, South Samuel, VT 64560	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:19:52.73283	2025-10-30 14:19:52.73283	\N
a864f157-a1b3-4e97-aae7-e0bb3f781073	STU-2025-031	Dennis	Torres	2020-04-02	female	98852 Allen Points Apt. 165, Briggsmouth, NY 27079	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:20:03.102904	2025-10-30 14:20:03.102904	\N
99171463-5c9d-4b02-ae42-ba4c12a5b697	STU-2025-032	Monica	Cannon	2010-12-26	male	965 Carney Way, East Brent, MI 72305	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:20:13.350363	2025-10-30 14:20:13.350363	\N
62393e02-8dc4-40ae-acd6-9e7aab16f92c	STU-2025-033	Nicole	Goodwin	2015-04-22	female	6151 William Highway, West Shawnfort, LA 32108	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:20:25.280071	2025-10-30 14:20:25.280071	\N
27618eab-cde9-487d-8adc-4dd1b4563f92	STU-2025-034	Brandi	Elliott	2019-07-20	male	3738 Forbes Squares Suite 435, Karenmouth, SD 98051	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:20:36.954089	2025-10-30 14:20:36.954089	\N
bfe221a6-9b31-4960-b428-88a0d007cabd	STU-2025-035	Tina	Taylor	2017-09-08	female	511 Contreras Walk, New Deborahmouth, DC 19141	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:20:48.200171	2025-10-30 14:20:48.200171	\N
1f5eda38-f94e-4764-8352-878214a0e330	STU-2025-036	John	Jones	2007-08-14	female	63217 Benjamin Well, Smithborough, AR 99305	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:21:07.586818	2025-10-30 14:21:07.586818	\N
7fc41845-1a63-450c-9c7d-75807687817e	STU-2025-037	Christopher	Oconnor	2010-10-06	female	2223 Julie Canyon, Port Brentstad, AR 77403	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:21:21.534896	2025-10-30 14:21:21.534896	\N
67c1327a-807b-4bdf-9ce5-0dbd96a77893	STU-2025-038	Mark	Johnson	2010-02-18	female	3144 Jensen Square, Davidfurt, WV 75844	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:21:35.83199	2025-10-30 14:21:35.83199	\N
a17bc597-89b9-4f4d-b04d-3974ea58dcaa	STU-2025-039	Savannah	Fernandez	2009-09-17	male	82205 Webb Springs, Tylermouth, MH 23153	67f6fc2a-deb5-408c-8ac7-975730d9cb70	t	2025-10-30 14:22:04.539875	2025-10-30 14:22:04.539875	\N
1656b9fb-7501-4202-a432-fd103ffff738	STU-2025-040	Richard	Mcdonald	2012-12-28	male	22093 Nguyen Islands, South Jonathan, FL 77235	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:23:14.531462	2025-10-30 14:23:14.531462	\N
1c712007-8146-4c58-b5b5-25e87dca6c2c	STU-2025-042	Jasmine	Palmer	2009-05-18	female	2419 King Vista Suite 447, Williambury, AS 79658	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:23:51.380713	2025-10-30 14:23:51.380713	\N
ccd343b5-2073-4c58-a146-25c56d4432f8	STU-2025-043	Sara	Morales	2018-02-24	female	181 Alexandra Village, Hilltown, MO 64616	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:24:06.078992	2025-10-30 14:24:06.078992	\N
3eea8f16-876e-4b45-8e2a-1d079c7f5b16	STU-2025-044	Christopher	Lucas	2018-05-06	female	06527 Davis Fall Apt. 617, New Mariebury, TX 50026	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:24:23.507616	2025-10-30 14:24:23.507616	\N
0474cd89-af32-4217-a78c-726e8c802e58	STU-2025-045	Joseph	Morgan	2016-01-08	female	6919 Martinez Estate Suite 931, Donnahaven, ND 28066	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:24:36.087814	2025-10-30 14:24:36.087814	\N
84343b8b-4771-45b6-9190-4ebf01c16561	STU-2025-046	Kayla	Oneal	2018-10-25	male	680 Cooper Lodge, Juliemouth, ND 28139	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:24:48.8545	2025-10-30 14:24:48.8545	\N
4ed32733-8072-43b1-afcc-1e064cd1e9b9	STU-2025-047	David	Santos	2016-06-11	male	84216 Smith Rest Apt. 234, New Andrewborough, NV 10655	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:24:58.129177	2025-10-30 14:24:58.129177	\N
76852c84-a03b-4b35-b638-ccbe7d9717a1	STU-2025-048	Andrew	Parker	2010-03-24	female	345 Brandi Springs Apt. 206, Amandafort, MH 27508	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:25:15.789867	2025-10-30 14:25:15.789867	\N
477d462a-6165-4d11-a46d-a43d1b9c7768	STU-2025-049	Jay	Perry	2011-10-27	male	73139 Eric Rest Suite 703, Christophermouth, MD 57406	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:25:36.49793	2025-10-30 14:25:36.49793	\N
b40c48db-adc2-4c9f-abb5-42cd86f127fe	STU-2025-050	Matthew	Travis	2017-07-05	female	907 Campos Pike, Clementshaven, TN 89381	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:25:58.880454	2025-10-30 14:25:58.880454	\N
a6cfe41d-2548-44ba-a4ae-be716478da09	STU-2025-051	Jessica	Bean	2018-06-05	male	2940 Haney Radial Apt. 182, Williamsonfort, NM 88209	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:26:32.784042	2025-10-30 14:26:32.784042	\N
856a1929-b3e2-46a8-86b2-e97dc46935fa	STU-2025-052	Kylie	Skinner	2011-10-30	male	750 David Hollow Apt. 802, Davisburgh, NJ 88470	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:27:29.777608	2025-10-30 14:27:29.777608	\N
ee79cdd6-5fdc-41f3-9c7e-493501913253	STU-2025-053	Cory	Baxter	2019-10-24	female	10859 Lisa Unions, West Brittanyfurt, PR 35857	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:27:40.151075	2025-10-30 14:27:40.151075	\N
ff56db77-04e3-4e9b-8d10-49ab82582233	STU-2025-054	Nicole	Manning	2015-07-08	female	82028 Peterson Drive Suite 021, North Raymondview, PW 40448	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:27:52.32501	2025-10-30 14:27:52.32501	\N
af6fcd68-fe50-4e9f-91a6-c99f492e8593	STU-2025-055	Sandra	Tate	2018-10-16	female	568 Weaver Turnpike Suite 160, Lake Rachel, ID 14103	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:28:03.923289	2025-10-30 14:28:03.923289	\N
6119fe1d-14f2-478b-934e-0034af52c647	STU-2025-056	Jason	Brown	2017-03-14	male	923 Martinez Parkways, Jadeshire, NC 99799	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:28:22.018615	2025-10-30 14:28:22.018615	\N
ce955be9-8dc3-492c-b0f2-b63d6722d8cf	STU-2025-057	Adriana	Mcdonald	2009-01-21	female	686 Sandra Coves Apt. 398, South April, IL 41896	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:29:12.564743	2025-10-30 14:29:12.564743	\N
fa83f8fa-5a6a-401d-947f-45817a147bda	STU-2025-058	Sheila	Lewis	2015-05-18	male	42127 Norman Prairie, Johnland, CT 42076	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:29:29.105668	2025-10-30 14:29:29.105668	\N
e69583bf-4703-43c2-b307-f6bd4d1367ae	STU-2025-059	Leslie	Murphy	2019-03-11	male	PSC 0627, Box 4390, APO AA 98732	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:33:02.372151	2025-10-30 14:33:02.372151	\N
04bb7f00-16bf-4d29-887f-1fd2c431a239	STU-2025-060	David	Johnson	2015-02-02	female	707 Santos Spring, New Kariview, PR 86205	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:34:06.298114	2025-10-30 14:34:06.298114	\N
c22a1051-b083-4380-a45f-6412fdcddd50	STU-2025-061	Eric	Mcgee	2009-08-27	female	785 Jasmine Parkways Suite 143, Gibsonstad, IA 01393	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:35:16.437113	2025-10-30 14:35:16.437113	\N
69ca057d-4216-4b11-b5d6-2d934f0c3cb2	STU-2025-062	Deanna	Powell	2010-02-25	male	9967 Smith Roads, West Jenniferview, SC 19327	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:35:25.747123	2025-10-30 14:35:25.747123	\N
775c41ff-60a0-4794-b74d-e4632b21817c	STU-2025-063	Pamela	Lee	2013-07-05	male	3548 Jill Crossroad Suite 566, Tonyhaven, MD 60369	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:35:34.988212	2025-10-30 14:35:34.988212	\N
6e00b41e-a6f3-4260-8330-447fab010c93	STU-2025-064	Kevin	Silva	2011-10-30	female	25775 Thomas Oval Suite 526, Cowanbury, PW 34475	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:35:45.136039	2025-10-30 14:35:45.136039	\N
72e0ed04-9a87-4214-a0c3-ec46b4519db2	STU-2025-065	Scott	Madden	2019-02-06	female	29924 Cheyenne Streets, New Angela, DE 78984	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:36:24.979471	2025-10-30 14:36:24.979471	\N
40ca9bbb-5afd-4ab6-bf7e-898b546b89eb	STU-2025-066	Mark	Fischer	2011-11-13	female	65718 Wood Points, Perezstad, IA 59202	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:45:52.780865	2025-10-30 14:45:52.780865	\N
4b2b5703-7ba4-4afc-8541-711ded89d878	STU-2025-067	David	Fields	2020-05-02	female	47234 Matthew Bridge Apt. 477, Lake Jenniferville, RI 63787	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:46:22.788456	2025-10-30 14:46:22.788456	\N
18bc33ae-d99a-41f3-ad90-e8c80acd954b	STU-2025-068	Jimmy	Martin	2009-11-13	female	8169 Stephanie Street, East Brandon, WY 15895	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:46:27.617026	2025-10-30 14:46:27.617026	\N
10975f77-cf5f-4b8e-81c6-8017c72360e1	STU-2025-069	Betty	Flores	2014-03-10	female	762 Glenn Well, East Emilyville, NE 98882	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:46:31.429983	2025-10-30 14:46:31.429983	\N
f442262a-0ef7-4bdd-8909-e8e81459b56a	STU-2025-070	Bradley	Peterson	2017-04-03	male	37001 William Plaza, West Nicholashaven, TN 47325	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:46:35.51098	2025-10-30 14:46:35.51098	\N
a207afc8-ddd6-4cd5-b5c7-c1d83732fdd3	STU-2025-071	Laura	Moore	2013-10-08	male	038 Burton Prairie, Evansport, SD 63733	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:46:39.724563	2025-10-30 14:46:39.724563	\N
f31c5114-12cc-4e2e-b3bd-cd0b6c9c16cb	STU-2025-072	William	Johnson	2018-06-02	male	0192 Moss Overpass, New Monicaburgh, MI 00553	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:46:42.692011	2025-10-30 14:46:42.692011	\N
5d94e046-0fcd-4b33-a5b0-070c020d349a	STU-2025-073	Danielle	Martinez	2010-12-22	female	0140 Reynolds Locks, Baxterport, MT 15248	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:46:45.853037	2025-10-30 14:46:45.853037	\N
cd4ed8bd-ddfc-4be9-ad1f-278573f9c06a	STU-2025-074	Jillian	Kramer	2014-07-11	female	0723 Renee Meadow Suite 864, Kristinahaven, DC 83836	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:46:49.371058	2025-10-30 14:46:49.371058	\N
700459ce-314b-4421-9d3a-27acc98a38da	STU-2025-075	Scott	Jimenez	2015-06-21	female	USS Martin, FPO AP 18069	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:46:53.840578	2025-10-30 14:46:53.840578	\N
8ba9b42c-da18-420b-b60d-3d482cf217bd	STU-2025-076	Julie	Duke	2013-03-10	female	27826 Kelly Shoal, West Jeremiah, IA 33606	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:46:57.219556	2025-10-30 14:46:57.219556	\N
6b733a50-ad7b-4252-ba91-8016313dc00f	STU-2025-077	Jane	Underwood	2011-05-24	male	699 Bennett Rest Apt. 187, Nicolemouth, MA 98840	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:47:01.942086	2025-10-30 14:47:01.942086	\N
7736a653-8173-4402-bac8-c68aea842766	STU-2025-078	Dalton	Davidson	2016-07-26	female	3222 Le Spurs Apt. 071, Wilsonberg, NJ 74517	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:47:05.386639	2025-10-30 14:47:05.386639	\N
2e20598f-607f-415d-a273-389d6ee1a8de	STU-2025-079	Kristine	James	2007-03-27	male	8522 Katherine Loaf, Thompsonchester, GU 84903	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:47:08.295585	2025-10-30 14:47:08.295585	\N
c2faa1b0-2b9b-438c-979f-45e6774e385b	STU-2025-080	Johnny	Harrison	2009-11-15	female	466 Hansen Cliffs, Toddfurt, FM 51698	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:47:37.702152	2025-10-30 14:47:37.702152	\N
66ff9037-2a53-40cd-b6e3-27bbb2fdb9d9	STU-2025-081	Jessica	Smith	2007-08-16	male	1312 Jonathon Knolls Apt. 299, Fredericktown, NC 53642	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:47:41.733696	2025-10-30 14:47:41.733696	\N
777155cb-b6ce-49fd-8e69-a23a0a036816	STU-2025-082	Allison	Martin	2016-02-05	male	007 Bell Road, New Thomas, OR 97546	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:47:45.559506	2025-10-30 14:47:45.559506	\N
6aad2a83-6b17-4e8e-961a-fab1d31103c1	STU-2025-083	Brittany	Vazquez	2015-08-21	male	8842 Angela Mountains Suite 225, East Kevin, PA 71057	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:47:49.427268	2025-10-30 14:47:49.427268	\N
51d870b7-24b5-4aa5-ac7a-c8b651241072	STU-2025-084	Matthew	Turner	2016-12-12	male	3245 Davis Cape Apt. 939, West Marc, NE 18020	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:47:54.610282	2025-10-30 14:47:54.610282	\N
d0170f13-040f-4e0a-b39d-38f9b9cdd8e7	STU-2025-085	Daniel	Smith	2014-07-06	female	USS Hale, FPO AE 17120	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:48:01.856263	2025-10-30 14:48:01.856263	\N
bdf10862-c484-4ccd-8306-d79ac1e1c9ed	STU-2025-086	Andrew	Hudson	2011-08-10	male	266 Ramirez Shoals Suite 521, South Stephanieton, NJ 41550	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:49:32.780962	2025-10-30 14:49:32.780962	\N
32e57d76-f679-4115-a5d0-85ff2cbddfac	STU-2025-087	Peggy	Chen	2017-03-04	male	232 Harding Shores Apt. 972, West Carolport, IL 44879	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:49:36.443347	2025-10-30 14:49:36.443347	\N
0061740c-ae81-4b3e-a49c-0f65f5ca2c45	STU-2025-088	Jennifer	Hodge	2007-04-09	male	5993 Adkins Estates Apt. 720, East Anthony, NC 89163	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:49:38.837464	2025-10-30 14:49:38.837464	\N
9e712caf-feca-4516-83c1-e936b6978be8	STU-2025-089	Carol	Hoffman	2018-09-06	male	38218 Gregory Forest Apt. 371, North Shannonberg, SC 83789	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:49:49.128061	2025-10-30 14:49:49.128061	\N
2c6d0982-1a79-4cff-ab58-7c7eb1a13bfb	STU-2025-090	Brian	Lewis	2011-03-28	male	7725 Hess Ridges Apt. 802, North Luisfort, HI 44973	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:49:52.834056	2025-10-30 14:49:52.834056	\N
c8befd5a-6c1c-4f29-b882-1a1680b97b14	STU-2025-091	Bonnie	Pineda	2012-07-23	male	91686 Johnson Via Apt. 421, East Lori, MN 04590	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:49:54.966145	2025-10-30 14:49:54.966145	\N
5cc81719-9bae-43b8-9eb5-9f15293fca61	STU-2025-092	Antonio	Brown	2016-10-26	female	02113 Bass Locks, Vazquezberg, LA 69458	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:49:57.400057	2025-10-30 14:49:57.400057	\N
3425274f-c668-415d-95d1-9717841fa2a9	STU-2025-093	Tasha	Lopez	2007-08-09	female	9513 Mcmillan Pine Suite 659, Allenshire, VT 97905	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:49:59.875212	2025-10-30 14:49:59.875212	\N
048c3c31-24db-457b-8b91-422d6e6df08f	STU-2025-094	Jacqueline	Young	2012-08-14	male	37978 Megan Locks, Port Adrian, MD 63015	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:50:03.987579	2025-10-30 14:50:03.987579	\N
94dac129-6f43-489a-998b-a5bf713bc534	STU-2025-095	Crystal	Perry	2017-02-23	male	3156 Ryan Islands, North Jessicaland, NE 71012	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:50:06.549083	2025-10-30 14:50:06.549083	\N
6b3390f7-c22a-49fa-a9c0-8c4820c254ce	STU-2025-096	Sara	Price	2018-06-16	female	91884 Anthony Junctions, Simmonsview, MD 29977	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:50:09.309601	2025-10-30 14:50:09.309601	\N
7ade8215-2538-48b5-8a36-0fa7d2e8462c	STU-2025-097	Anthony	Dixon	2015-02-20	male	5777 Thompson Inlet Apt. 753, Port Gilbertborough, FM 97703	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:50:58.816252	2025-10-30 14:50:58.816252	\N
0590e0cd-307d-48ea-8661-c435e75287f7	STU-2025-098	Spencer	Thompson	2010-03-01	male	5932 Lisa Inlet, Bakerstad, DE 50303	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:51:01.939692	2025-10-30 14:51:01.939692	\N
bfa9bd79-be0a-410d-b9e9-2dae995167c0	STU-2025-099	Robert	Brooks	2008-04-22	male	35345 Burton Forge Apt. 612, West Sandraport, MT 29019	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:51:04.228714	2025-10-30 14:51:04.228714	\N
35ae3165-7941-4cbe-bb6b-e7ac996447b4	STU-2025-100	Sean	Jones	2016-02-21	male	Unit 1280 Box 1325, DPO AE 71222	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:51:07.376803	2025-10-30 14:51:07.376803	\N
c04fc369-217a-42af-a946-7de7c759c977	STU-2025-101	Joshua	Lewis	2020-01-29	female	1801 Vernon Orchard Apt. 724, Lake Gabrielle, PR 13501	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:51:10.021286	2025-10-30 14:51:10.021286	\N
981438b1-e7a1-4cd2-9c98-7af333e41167	STU-2025-102	Steven	Johnson	2017-08-22	male	10585 Omar Glen, New Rebecca, PR 66495	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:51:13.08171	2025-10-30 14:51:13.08171	\N
187fc776-2ce7-4e27-bd6b-4668a7e375c6	STU-2025-103	Kim	Smith	2009-10-28	male	8683 Steven Dale Suite 027, New Vanessa, ME 43390	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:51:15.765491	2025-10-30 14:51:15.765491	\N
049aa48f-1c19-4785-a5e1-517875e46acc	STU-2025-104	Ann	Pierce	2017-05-28	female	663 Fischer Course Suite 789, Collinsberg, AS 40641	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:51:17.824781	2025-10-30 14:51:17.824781	\N
5c500668-c7a2-4413-8db1-dd52e686b74c	STU-2025-105	Peter	Mejia	2017-08-08	female	07622 Cynthia Meadows, Bruceview, OR 55953	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:51:22.25202	2025-10-30 14:51:22.25202	\N
b9212c08-d93c-4363-ad98-152e7b2a6057	STU-2025-106	Nicole	Garcia	2016-07-26	female	6542 Butler Loaf Apt. 425, Silvaside, PR 33778	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:51:30.943623	2025-10-30 14:51:30.943623	\N
66d242ae-f1a0-4aee-ade4-0f24b6be0b33	STU-2025-107	Jeffery	Waller	2008-05-09	female	3964 Johnson Squares, Johnsonberg, NV 28747	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:52:08.355638	2025-10-30 14:52:08.355638	\N
2b0e6567-dfcd-4cfa-ac68-867126d9afdf	STU-2025-108	Randy	Thornton	2012-10-03	male	48209 Terri Junction Apt. 485, Leahmouth, AK 98628	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:52:11.042183	2025-10-30 14:52:11.042183	\N
1d376eb2-0065-4926-9139-3a0fb011a854	STU-2025-109	Paul	Vasquez	2016-05-10	male	7362 Richard Walks, South Amanda, HI 36125	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:52:13.70515	2025-10-30 14:52:13.70515	\N
d1c77b5e-ebda-473b-a8f7-7c7614e8b074	STU-2025-110	Robin	Allen	2015-01-31	male	8885 Reeves Keys Suite 322, East Sean, NM 14379	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:52:15.693879	2025-10-30 14:52:15.693879	\N
d40a1996-7f67-4463-b294-88f25ccbaa05	STU-2025-111	Robin	Henderson	2012-07-15	female	6882 Porter Cove Suite 321, Mendezland, MT 48393	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:52:20.320656	2025-10-30 14:52:20.320656	\N
84639900-5e24-46b4-b8f2-10b4ea262cf8	STU-2025-112	Samantha	Torres	2014-05-18	male	09231 John Freeway, Figueroabury, NE 14523	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:52:25.035187	2025-10-30 14:52:25.035187	\N
9956784e-aaa5-4737-a8e8-ab1fc81a324d	STU-2025-113	Kaitlin	May	2015-03-17	male	831 Baldwin Light Suite 044, Port Roseside, CA 56107	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:52:27.875216	2025-10-30 14:52:27.875216	\N
a9a17332-6455-498a-9f5d-d469a660407b	STU-2025-114	Brittany	Johnson	2015-01-18	female	USNS Braun, FPO AP 88695	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:52:30.517663	2025-10-30 14:52:30.517663	\N
7f5fcc52-1981-4155-8b59-b45e624e44e5	STU-2025-115	Tiffany	Roberts	2019-04-12	female	5487 Rose Station, North Angela, WA 20480	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:52:35.444786	2025-10-30 14:52:35.444786	\N
8b6fd685-eff1-4ba1-9a8e-776e8b4f335f	STU-2025-116	Kelli	Stephens	2014-05-11	female	3720 Donald Islands Apt. 163, Laneport, TX 42081	e455acf0-395b-4236-8ce0-ad5fc972d19b	t	2025-10-30 14:52:39.954268	2025-10-30 14:52:39.954268	\N
cba874c0-472a-481c-b203-1f8beb00fec4	STU-2025-117	Erik	Lane	2018-08-14	female	49896 Brown Road, New Tammytown, IL 65693	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:52:43.175939	2025-10-30 14:52:43.175939	\N
95ed9be6-69b1-40df-b908-a73a97a4582d	STU-2025-118	Eric	Santos	2007-05-24	female	026 Steven Rue, Lake Amandaborough, MS 40903	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:52:46.422189	2025-10-30 14:52:46.422189	\N
218a40cf-62c1-4fe2-9bfe-c8a4b236b639	STU-2025-119	Jeffrey	Doyle	2018-02-16	male	83692 Padilla Camp, Annaside, KS 42659	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:52:48.721686	2025-10-30 14:52:48.721686	\N
b6fc5e1b-91df-4818-a57c-2cb4d2990080	STU-2025-120	Maria	Arnold	2008-02-21	male	03799 Gardner Viaduct Suite 274, West Debrastad, NY 46571	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:52:51.251728	2025-10-30 14:52:51.251728	\N
c7cfdfb6-9b58-4d6b-8c81-742aa3559012	STU-2025-121	Kathleen	Richardson	2013-02-09	male	5315 Christine Common, Brandonborough, AS 81828	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:52:53.3217	2025-10-30 14:52:53.3217	\N
10b3d287-212b-414c-b980-f86c5dbf9379	STU-2025-122	Scott	Carr	2015-03-13	female	7605 Donald Isle, Ashleymouth, NM 89130	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:52:54.956239	2025-10-30 14:52:54.956239	\N
74eb0d9d-36ce-49bb-9879-3b655071ed5d	STU-2025-123	Jennifer	Collins	2009-10-20	male	66080 Andrew Crescent, Jonesburgh, NC 74740	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:52:57.174236	2025-10-30 14:52:57.174236	\N
eb334d6f-c2ad-4e75-b13e-bebc0a881caa	STU-2025-124	Christine	Robertson	2016-12-31	female	46816 Timothy Keys Apt. 872, Rodriguezmouth, CA 41163	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:52:58.792197	2025-10-30 14:52:58.792197	\N
255f0a69-958b-44db-9d26-4e6ef5e0539e	STU-2025-125	Melissa	Smith	2016-05-31	male	861 Ashley Curve, West Robert, MP 57008	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:53:00.944247	2025-10-30 14:53:00.944247	\N
6212077c-a2e2-4258-be34-44152e6738f3	STU-2025-126	Judy	Harris	2013-12-17	female	0277 Karen Estate Apt. 264, Mariaton, RI 95630	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:53:02.555265	2025-10-30 14:53:02.555265	\N
91a6ad2c-fd24-4022-b6b6-d82f0049f24c	STU-2025-127	Oscar	Smith	2011-11-07	female	2504 Gary Mount Apt. 362, Allenburgh, NM 72100	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:53:04.164754	2025-10-30 14:53:04.164754	\N
560d3407-6354-43fe-9d00-0c7c3cdb6a27	STU-2025-128	Alexandra	Lester	2019-11-03	female	358 Thornton Manors, New Pamela, HI 30662	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:53:05.779773	2025-10-30 14:53:05.779773	\N
87d56066-a631-4e5c-beb6-2213a05b04d6	STU-2025-129	Wesley	Griffin	2007-05-13	female	03586 Doyle Divide, Alejandroburgh, AK 66682	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:53:10.042234	2025-10-30 14:53:10.042234	\N
db17bf48-4d11-4231-814b-8420148478f8	STU-2025-130	John	Caldwell	2012-08-27	male	21422 Watts Locks Apt. 709, New Theresa, NE 81751	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:53:12.22125	2025-10-30 14:53:12.22125	\N
f4929bfa-749c-40bc-a366-900c0adf608b	STU-2025-131	Jason	Briggs	2013-09-05	male	4394 Lisa Ramp Apt. 090, Vangfurt, TX 11421	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:53:13.941713	2025-10-30 14:53:13.941713	\N
9d2401a0-e15d-4d46-a23e-144c6916701c	STU-2025-132	Jennifer	Price	2011-12-11	male	5082 Julie Neck, Gregoryton, KS 15715	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:53:16.042265	2025-10-30 14:53:16.042265	\N
c8125e9f-cf06-4561-bec7-9b534ebe36b4	STU-2025-133	Ronald	Harper	2012-03-16	male	Unit 7003 Box 6192, DPO AP 78546	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:53:18.376772	2025-10-30 14:53:18.376772	\N
5a422dfc-0f4a-4815-9126-7d73938c04e8	STU-2025-134	Jesse	Williams	2006-11-15	male	38546 Davis Spring, Thomasbury, AS 26112	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:53:45.824834	2025-10-30 14:53:45.824834	\N
12d6d4fd-c53c-4741-b621-3e073836c3fc	STU-2025-135	Kyle	Chavez	2018-02-28	male	68732 Gonzalez Shoals Suite 920, Patrickborough, PR 41162	746a6e69-a337-4d3a-9050-fec30acae340	t	2025-10-30 14:54:39.940365	2025-10-30 14:54:39.940365	\N
caea02af-b453-43d5-aec8-fc1271477c5b	STU-2025-136	Deborah	Williams	2012-10-13	male	928 Stanley Valleys Suite 154, Schmidtburgh, FL 14674	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:54:54.388554	2025-10-30 14:54:54.388554	\N
459c9b34-7bb8-42a1-9b94-27f325f8c1ff	STU-2025-137	Sean	Green	2008-03-31	male	289 Sarah Square, West Renee, NC 77318	03dbe0a8-1bb8-4751-bd7f-3fdd2eeadb05	t	2025-10-30 14:54:57.184544	2025-10-30 14:54:57.184544	\N
f3319a75-81cd-423c-b35e-61defea2512f	STU-2025-138	Barbara	Moore	2019-07-02	female	7573 Roberts Road Apt. 017, Christophermouth, NY 92136	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:55:05.642087	2025-10-30 14:55:05.642087	\N
8e0dd30a-349a-4b7c-8cf0-452b213bf9d7	STU-2025-139	Thomas	White	2019-01-16	male	827 Amy Centers Suite 329, Deannaside, KS 34205	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:55:07.585943	2025-10-30 14:55:07.585943	\N
b7946e2d-aa2a-47e9-ac0b-138fb648b6db	STU-2025-140	Christopher	Velasquez	2017-03-10	female	44245 Wilson Forks Apt. 639, North Dominiquetown, MA 28813	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:55:09.789066	2025-10-30 14:55:09.789066	\N
c7cbee27-6332-4e0e-b239-811b7e84c21d	STU-2025-141	Michael	Mccoy	2007-12-23	female	1807 Johnson Knoll, East Staceystad, NC 72110	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:55:11.420589	2025-10-30 14:55:11.420589	\N
11f8d9a6-3d9b-4803-b98c-e1579720e0b7	STU-2025-142	Maria	Garcia	2015-10-20	female	PSC 0543, Box 2306, APO AE 22320	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:55:13.602143	2025-10-30 14:55:13.602143	\N
da450125-228f-4d07-baf2-35099b138251	STU-2025-143	Emily	Singh	2020-03-23	female	3338 Richard Prairie Apt. 728, North Amy, OR 70600	0446f859-3fe7-4148-a5b0-b2732fb505ee	t	2025-10-30 14:55:17.256188	2025-10-30 14:55:17.256188	\N
e029a019-d0a8-4203-83f8-fead6f15a9e8	STU-2025-144	Jennifer	Murphy	2010-04-09	female	0688 Randy Cliff, East Michaelview, GA 22124	6132551e-91a2-4685-9702-5726be5eba43	t	2025-10-30 14:58:52.453793	2025-10-30 14:58:52.453793	\N
8f8e3893-ad14-44cd-acfc-d5feb1a9e762	STU-2025-145	Christopher	Little	2017-11-07	female	899 Lauren Motorway, East Jimmyberg, GA 21305	a93a538e-9879-45de-8fb0-8a1709ddbdfb	t	2025-10-30 14:59:48.077594	2025-10-30 14:59:48.077594	\N
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.subjects (id, name, code, department_id, is_active, created_at, updated_at, deleted_at) FROM stdin;
746b5667-0805-4745-977a-c8e2f9d4995a	English	ENG	2b93eb17-fba0-46d7-ae2b-80ba652faacc	t	2025-10-24 17:00:36.569718+00	2025-11-06 20:58:41.571452+00	\N
d87935ca-83ee-4e43-a3dd-edbf4dd583c4	Mathematics	MAT	1d0663c9-f914-4ba5-baa8-453a768886f0	t	2025-10-24 16:50:53.50429+00	2025-11-06 20:58:41.571452+00	\N
6808b921-e9ba-4abe-9c56-9c061bf88537	Science	SCI	225609db-adf9-4c55-83fb-5e880dd9481e	t	2025-10-24 17:01:38.007375+00	2025-11-06 20:58:41.571452+00	\N
39c95292-248f-4786-a8e1-8cf8a0e125e8	Social Studies	SST	dc13b32b-cb13-4fef-9d38-79b24f6c6b60	t	2025-10-24 16:59:28.367921+00	2025-11-06 20:58:41.571452+00	\N
\.


--
-- Data for Name: teacher_availability; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.teacher_availability (id, teacher_id, day_of_week, is_available, start_time, end_time, created_at, updated_at) FROM stdin;
5c9b95d0-c408-4005-afb5-5830747f62d2	2f5932e3-af2e-413e-8bc4-59113d16a366	6	t	07:20:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
11e0f9f3-5464-4538-a192-7ed7e353ccc7	2f5932e3-af2e-413e-8bc4-59113d16a366	0	t	07:20:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
5a0d6538-c3e6-4ccd-a3e6-2185c3d169a4	77d5ac90-58e3-4257-bc55-f04e417a4601	1	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
f9acd625-82e5-4ec3-b85c-0a31e0355122	77d5ac90-58e3-4257-bc55-f04e417a4601	2	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
8da0284f-bfa6-4578-848c-baaeba64a098	77d5ac90-58e3-4257-bc55-f04e417a4601	3	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
660e0a9b-5654-4dfb-844f-c2571830759b	77d5ac90-58e3-4257-bc55-f04e417a4601	4	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
db824bec-4eec-4448-8443-f80fbaefff6d	77d5ac90-58e3-4257-bc55-f04e417a4601	5	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
92ca0825-ba9d-45c5-ab7a-e3b0d657d40b	77d5ac90-58e3-4257-bc55-f04e417a4601	6	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
0f58d6ce-3b0d-4ea7-9ba0-6cbb5ed0ab02	77d5ac90-58e3-4257-bc55-f04e417a4601	0	t	07:20:00	17:00:00	2025-11-18 15:20:07.982387+00	2025-11-18 15:20:07.982387+00
b1e0c8cc-38a3-4e77-a3a3-34a1bf81a568	4dd408fa-7666-4d4c-b8e2-251e999f3175	1	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
6aa3f6d1-e90a-428b-81fe-308d300eb16f	4dd408fa-7666-4d4c-b8e2-251e999f3175	2	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
9aac94ea-28f7-418d-931a-ecaa2a2d8888	4dd408fa-7666-4d4c-b8e2-251e999f3175	3	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
8a728b15-9265-40fa-8b08-6b3599c8871d	4dd408fa-7666-4d4c-b8e2-251e999f3175	4	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
d0528608-c4f6-4f47-b1fe-c0f7cb78edc2	4dd408fa-7666-4d4c-b8e2-251e999f3175	5	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
b08511d2-2bb0-4b53-a304-99889dfda2e8	4dd408fa-7666-4d4c-b8e2-251e999f3175	6	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
033b4549-6095-4b89-a708-9d8ea0806a8f	4dd408fa-7666-4d4c-b8e2-251e999f3175	0	t	07:20:00	17:00:00	2025-11-18 15:21:36.025023+00	2025-11-18 15:21:36.025023+00
c32b67ae-4fcb-4a0b-ad6b-8d34a37e1e07	f389b565-0c15-44bd-9748-8fe1ff20bc67	1	t	07:20:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
8f0a5751-d2ce-41ab-9e69-9a43bea2fe54	f389b565-0c15-44bd-9748-8fe1ff20bc67	2	t	07:00:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
2fb0c417-7948-4656-9b0a-a074b8cb9b45	f389b565-0c15-44bd-9748-8fe1ff20bc67	3	t	07:20:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
b1cc76d6-5b1a-4ac3-8b7b-bdcc766144c5	f389b565-0c15-44bd-9748-8fe1ff20bc67	4	t	07:20:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
f5e3b050-e38c-4c60-a942-95a37d2a38d2	f389b565-0c15-44bd-9748-8fe1ff20bc67	5	t	07:20:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
366ff0c9-06a2-43aa-8668-1a2829838a19	f389b565-0c15-44bd-9748-8fe1ff20bc67	6	t	07:20:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
1864aa79-4f31-4f4e-bf9e-9221e07f86e9	f389b565-0c15-44bd-9748-8fe1ff20bc67	0	t	07:20:00	17:00:00	2025-11-16 00:10:56.934532+00	2025-11-18 15:22:37.24977+00
66384002-2d3e-4bab-ab08-2374511a3369	5fa24ba5-d4c3-4480-97de-a42f7706c79a	1	f	\N	\N	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
90464ab8-467a-4ecc-b462-07beea46fbf7	5fa24ba5-d4c3-4480-97de-a42f7706c79a	2	t	07:20:00	17:00:00	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
52f71a4d-a2c7-483a-9a86-d682afc2997e	5fa24ba5-d4c3-4480-97de-a42f7706c79a	3	f	\N	\N	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
b38e53a0-c9d5-49ba-b802-2043124fdd3d	5fa24ba5-d4c3-4480-97de-a42f7706c79a	4	f	\N	\N	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
3f750fdc-0a99-45ac-86ac-bfd0b782f327	5fa24ba5-d4c3-4480-97de-a42f7706c79a	5	f	\N	\N	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
21496a1a-3b8e-4d92-9f24-84b799c5b4b5	5fa24ba5-d4c3-4480-97de-a42f7706c79a	6	f	\N	\N	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
1487f1e3-bdd2-4ed2-bb33-bd1a42b6d378	5fa24ba5-d4c3-4480-97de-a42f7706c79a	0	f	\N	\N	2025-11-16 19:38:02.489857+00	2025-11-16 19:38:02.489857+00
ddc639f3-7194-4f49-bfae-f6884decc09c	798b1752-83d0-416c-a097-056328c7d56c	1	t	07:20:00	16:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
144d48c5-1788-472a-bc4f-399c9f9de83c	798b1752-83d0-416c-a097-056328c7d56c	2	t	07:20:00	17:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
95af5114-2a7b-4fda-9418-d24e65a8f4ff	798b1752-83d0-416c-a097-056328c7d56c	3	t	07:20:00	17:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
4de9cfaa-0fd3-43b9-a058-dd7403e8450e	798b1752-83d0-416c-a097-056328c7d56c	4	t	07:20:00	17:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
32102461-6be9-4213-9c8b-1ffaa5cec472	798b1752-83d0-416c-a097-056328c7d56c	5	t	07:20:00	13:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
87cc6b7a-f949-46c4-8cb1-74a741942919	798b1752-83d0-416c-a097-056328c7d56c	6	t	07:20:00	17:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
bd9742d8-b0af-4cc0-a82f-faa1afbf774e	798b1752-83d0-416c-a097-056328c7d56c	0	t	07:20:00	17:00:00	2025-11-10 23:40:54.161817+00	2025-11-18 15:17:29.897195+00
0e81f1eb-a151-4b14-b773-e55a3c2ebbf8	2f5932e3-af2e-413e-8bc4-59113d16a366	1	t	07:20:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
ad79e1d0-6b7c-43ed-8361-8251479a68f3	2f5932e3-af2e-413e-8bc4-59113d16a366	2	t	07:20:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
2ca8c0e4-46b4-4939-9aea-5fa47471c722	2f5932e3-af2e-413e-8bc4-59113d16a366	3	t	07:20:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
e71f997b-d75e-461f-81d3-25dc8dd9c536	2f5932e3-af2e-413e-8bc4-59113d16a366	4	t	07:20:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
529e316c-071e-454b-91f5-be7ef0a7eeea	2f5932e3-af2e-413e-8bc4-59113d16a366	5	t	07:00:00	17:00:00	2025-11-16 13:21:08.478868+00	2025-11-18 15:19:00.609147+00
\.


--
-- Data for Name: teacher_subjects; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.teacher_subjects (teacher_id, subject_id, paper_id) FROM stdin;
cbe8de30-0d7f-4f0b-bb7c-abbd4d6ea192	746b5667-0805-4745-977a-c8e2f9d4995a	\N
5fa24ba5-d4c3-4480-97de-a42f7706c79a	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	84a89914-57d1-47fd-a94d-04dd9839d555
5fa24ba5-d4c3-4480-97de-a42f7706c79a	6808b921-e9ba-4abe-9c56-9c061bf88537	471cce99-01a8-4378-8b56-996c88549784
798b1752-83d0-416c-a097-056328c7d56c	746b5667-0805-4745-977a-c8e2f9d4995a	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9
798b1752-83d0-416c-a097-056328c7d56c	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	84a89914-57d1-47fd-a94d-04dd9839d555
798b1752-83d0-416c-a097-056328c7d56c	6808b921-e9ba-4abe-9c56-9c061bf88537	471cce99-01a8-4378-8b56-996c88549784
798b1752-83d0-416c-a097-056328c7d56c	39c95292-248f-4786-a8e1-8cf8a0e125e8	d755d10b-c757-408a-827c-8d8db0950375
2f5932e3-af2e-413e-8bc4-59113d16a366	746b5667-0805-4745-977a-c8e2f9d4995a	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9
2f5932e3-af2e-413e-8bc4-59113d16a366	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	84a89914-57d1-47fd-a94d-04dd9839d555
2f5932e3-af2e-413e-8bc4-59113d16a366	6808b921-e9ba-4abe-9c56-9c061bf88537	471cce99-01a8-4378-8b56-996c88549784
2f5932e3-af2e-413e-8bc4-59113d16a366	39c95292-248f-4786-a8e1-8cf8a0e125e8	d755d10b-c757-408a-827c-8d8db0950375
77d5ac90-58e3-4257-bc55-f04e417a4601	746b5667-0805-4745-977a-c8e2f9d4995a	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9
77d5ac90-58e3-4257-bc55-f04e417a4601	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	84a89914-57d1-47fd-a94d-04dd9839d555
77d5ac90-58e3-4257-bc55-f04e417a4601	6808b921-e9ba-4abe-9c56-9c061bf88537	471cce99-01a8-4378-8b56-996c88549784
77d5ac90-58e3-4257-bc55-f04e417a4601	39c95292-248f-4786-a8e1-8cf8a0e125e8	d755d10b-c757-408a-827c-8d8db0950375
4dd408fa-7666-4d4c-b8e2-251e999f3175	746b5667-0805-4745-977a-c8e2f9d4995a	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9
4dd408fa-7666-4d4c-b8e2-251e999f3175	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	84a89914-57d1-47fd-a94d-04dd9839d555
4dd408fa-7666-4d4c-b8e2-251e999f3175	6808b921-e9ba-4abe-9c56-9c061bf88537	471cce99-01a8-4378-8b56-996c88549784
4dd408fa-7666-4d4c-b8e2-251e999f3175	39c95292-248f-4786-a8e1-8cf8a0e125e8	d755d10b-c757-408a-827c-8d8db0950375
f389b565-0c15-44bd-9748-8fe1ff20bc67	746b5667-0805-4745-977a-c8e2f9d4995a	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9
f389b565-0c15-44bd-9748-8fe1ff20bc67	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	84a89914-57d1-47fd-a94d-04dd9839d555
f389b565-0c15-44bd-9748-8fe1ff20bc67	6808b921-e9ba-4abe-9c56-9c061bf88537	471cce99-01a8-4378-8b56-996c88549784
f389b565-0c15-44bd-9748-8fe1ff20bc67	39c95292-248f-4786-a8e1-8cf8a0e125e8	d755d10b-c757-408a-827c-8d8db0950375
\.


--
-- Data for Name: terms; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.terms (id, academic_year_id, name, start_date, end_date, is_current, is_active, created_at, updated_at, deleted_at) FROM stdin;
67e072c7-bae8-4e31-9acd-7359301211fb	18ec3760-d96b-4471-947a-d0702dd3edb6	Term 1	2024-01-01	2024-04-30	t	t	2025-11-11 19:46:51.761437+00	2025-11-11 19:46:51.761437+00	\N
96f5f1fd-fb85-41a1-a0f8-ad5b2e2c1fee	457b88c8-63c4-402a-a2e2-c39d46d64409	Term 2	2025-10-30	2025-12-07	f	t	2025-11-11 21:03:38.961461+00	2025-11-11 21:03:38.961461+00	\N
\.


--
-- Data for Name: timetable_entries; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.timetable_entries (id, class_id, subject_id, teacher_id, paper_id, day_of_week, start_time, end_time, is_active, created_at, updated_at, deleted_at) FROM stdin;
fb08dc77-8959-498f-b025-ba0ff90ef481	67f6fc2a-deb5-408c-8ac7-975730d9cb70	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	f389b565-0c15-44bd-9748-8fe1ff20bc67	84a89914-57d1-47fd-a94d-04dd9839d555	monday	07:20:00	08:40:00	t	2025-11-18 15:14:22.114418+00	2025-11-18 15:14:22.114418+00	\N
49a823b3-8011-4cc8-88f8-1c2637831e6f	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	monday	07:20:00	08:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
fc5883e4-4e56-4421-9611-69553117eca7	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	f389b565-0c15-44bd-9748-8fe1ff20bc67	84a89914-57d1-47fd-a94d-04dd9839d555	tuesday	07:20:00	08:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
168e0837-4d87-4e2f-ba27-4244ca4ef7af	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	wednesday	07:20:00	08:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
e017a52f-fd17-4e9f-b0e1-2ec135922958	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	f389b565-0c15-44bd-9748-8fe1ff20bc67	d755d10b-c757-408a-827c-8d8db0950375	thursday	07:20:00	08:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
ca8ed595-2310-4bf7-8e33-68f8a41332df	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	2f5932e3-af2e-413e-8bc4-59113d16a366	d755d10b-c757-408a-827c-8d8db0950375	friday	07:20:00	08:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
58353b3d-546c-4d30-8d96-104b0c1ad0e7	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	f389b565-0c15-44bd-9748-8fe1ff20bc67	d755d10b-c757-408a-827c-8d8db0950375	saturday	07:20:00	08:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
859901e6-af6d-4eac-9039-2422abbdbd4c	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	monday	08:40:00	10:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
131db124-3a78-4c92-9bbe-7b9a7e955a0f	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	tuesday	08:40:00	10:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
dada844e-e175-4349-b363-b1be3980c4d2	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	4dd408fa-7666-4d4c-b8e2-251e999f3175	d755d10b-c757-408a-827c-8d8db0950375	wednesday	08:40:00	10:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
49ca451f-9cbe-42e4-ba35-699f071b81b1	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	f389b565-0c15-44bd-9748-8fe1ff20bc67	84a89914-57d1-47fd-a94d-04dd9839d555	thursday	08:40:00	10:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
2a2fc44a-e58d-41b1-ac65-ba3310fdc702	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	77d5ac90-58e3-4257-bc55-f04e417a4601	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	friday	08:40:00	10:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
e40f2e8b-e4b7-4e9b-a2de-28f1d14489e4	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	2f5932e3-af2e-413e-8bc4-59113d16a366	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	saturday	08:40:00	10:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
1785f200-3069-4acc-883b-c02f0569e05e	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	monday	10:20:00	11:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
524908d6-6887-45a2-a95d-8c60d94d99e4	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	tuesday	10:20:00	11:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
c8d292fb-3cf6-4a6b-93d3-74bd2bb81229	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	77d5ac90-58e3-4257-bc55-f04e417a4601	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	wednesday	10:20:00	11:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
a23ddb2f-96e7-4025-a54d-cfb118605299	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	2f5932e3-af2e-413e-8bc4-59113d16a366	84a89914-57d1-47fd-a94d-04dd9839d555	thursday	10:20:00	11:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
490c357c-ca2e-4440-9bf5-9107288dd0a8	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	friday	10:20:00	11:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
4d408c1c-d33e-4ceb-a1c9-b0799f2c8794	6132551e-91a2-4685-9702-5726be5eba43	6808b921-e9ba-4abe-9c56-9c061bf88537	798b1752-83d0-416c-a097-056328c7d56c	471cce99-01a8-4378-8b56-996c88549784	saturday	10:20:00	11:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
9deb1e52-d80f-4133-8eab-b59729fe5698	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	2f5932e3-af2e-413e-8bc4-59113d16a366	d755d10b-c757-408a-827c-8d8db0950375	monday	11:40:00	13:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
829bc5b2-5448-464e-9d81-5cef85da3daf	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	tuesday	11:40:00	13:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
921836aa-4394-4484-8f4d-58499d9c4b3f	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	4dd408fa-7666-4d4c-b8e2-251e999f3175	84a89914-57d1-47fd-a94d-04dd9839d555	wednesday	11:40:00	13:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
9a15b0fc-91c5-4712-9a30-b16a11a8d46b	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	4dd408fa-7666-4d4c-b8e2-251e999f3175	84a89914-57d1-47fd-a94d-04dd9839d555	thursday	11:40:00	13:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
53a838a5-6861-447c-925b-4fa820aa825c	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	4dd408fa-7666-4d4c-b8e2-251e999f3175	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	friday	11:40:00	13:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
0014ad10-46c3-4875-a34e-d6c95d318980	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	saturday	11:40:00	13:00:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
fee21e04-2c4d-485e-9eda-49a2a0d22aa8	6132551e-91a2-4685-9702-5726be5eba43	39c95292-248f-4786-a8e1-8cf8a0e125e8	2f5932e3-af2e-413e-8bc4-59113d16a366	d755d10b-c757-408a-827c-8d8db0950375	monday	14:00:00	15:20:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
e2dcffd6-f454-4883-a236-b9c5b8a716cb	6132551e-91a2-4685-9702-5726be5eba43	6808b921-e9ba-4abe-9c56-9c061bf88537	f389b565-0c15-44bd-9748-8fe1ff20bc67	471cce99-01a8-4378-8b56-996c88549784	tuesday	14:00:00	15:20:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
02a31444-962f-4d3c-aa61-ea1fdfb68c57	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	77d5ac90-58e3-4257-bc55-f04e417a4601	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	wednesday	14:00:00	15:20:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
908ed5e5-3b92-4ecf-82dc-aad1400eb485	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	4dd408fa-7666-4d4c-b8e2-251e999f3175	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	thursday	14:00:00	15:20:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
dde438db-a785-4f89-af31-3f102275b7ed	6132551e-91a2-4685-9702-5726be5eba43	6808b921-e9ba-4abe-9c56-9c061bf88537	77d5ac90-58e3-4257-bc55-f04e417a4601	471cce99-01a8-4378-8b56-996c88549784	friday	14:00:00	15:20:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
a25ae4d0-6b65-4c9b-96eb-8adca3ebf219	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	f389b565-0c15-44bd-9748-8fe1ff20bc67	84a89914-57d1-47fd-a94d-04dd9839d555	monday	15:20:00	16:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
c8d03828-780d-4393-96d0-424d27e64066	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	798b1752-83d0-416c-a097-056328c7d56c	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	tuesday	15:20:00	16:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
fc72a782-f6c9-48dc-87ff-1243d493648c	6132551e-91a2-4685-9702-5726be5eba43	746b5667-0805-4745-977a-c8e2f9d4995a	4dd408fa-7666-4d4c-b8e2-251e999f3175	f674e0f9-cb8a-40ce-b00f-cb8b2cbabfa9	wednesday	15:20:00	16:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
51b2033a-32e9-4a9d-b917-c4183f050c20	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	4dd408fa-7666-4d4c-b8e2-251e999f3175	84a89914-57d1-47fd-a94d-04dd9839d555	thursday	15:20:00	16:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
02b46166-082a-4d1e-aaaa-522f3f09ecde	6132551e-91a2-4685-9702-5726be5eba43	d87935ca-83ee-4e43-a3dd-edbf4dd583c4	4dd408fa-7666-4d4c-b8e2-251e999f3175	84a89914-57d1-47fd-a94d-04dd9839d555	friday	15:20:00	16:40:00	t	2025-11-18 15:51:41.682594+00	2025-11-18 15:51:41.682594+00	\N
\.


--
-- Data for Name: timetable_settings; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.timetable_settings (id, class_id, days, start_time, end_time, lesson_duration, breaks, is_default, created_at, updated_at) FROM stdin;
561d1178-1b81-4b07-b968-c2c5e0543b7e		["monday","tuesday","wednesday","thursday","friday"]	08:00:00	16:00:00	60	[{"name":"Breakfast Break","start_time":"10:00","end_time":"10:30"},{"name":"Lunch Break","start_time":"12:30","end_time":"13:30"}]	f	2025-11-09 14:10:53.359477+00	2025-11-09 14:10:53.359477+00
e95cebf2-8a8c-43c0-bfa4-f62d006e9f0d		["monday","tuesday","wednesday","thursday","friday","saturday"]	08:00:00	17:00:00	60	[{"name":"Breakfast Break","start_time":"10:00","end_time":"11:00"},{"name":"Lunch Break","start_time":"13:00","end_time":"14:00"}]	t	2025-11-14 14:38:12.559617+00	2025-11-14 14:38:12.559617+00
f701a52b-707c-422a-9869-da67a2371d65	6132551e-91a2-4685-9702-5726be5eba43	["monday","tuesday","wednesday","thursday","friday","saturday"]	07:20:00	16:40:00	80	[{"end_time":"10:20","name":"Breakfast","start_time":"10:00"},{"end_time":"14:00","name":"Lunch","start_time":"13:00"}]	f	2025-11-09 14:45:32.074482+00	2025-11-16 13:59:02.515768+00
b5ae8543-6c6e-4c3f-826c-9bc1547a5560	67f6fc2a-deb5-408c-8ac7-975730d9cb70	["monday","tuesday","wednesday","thursday","friday","saturday"]	07:20:00	16:40:00	80	[{"end_time":"11:00","name":"Breakfast Break","start_time":"10:00"},{"end_time":"14:00","name":"Lunch Break","start_time":"13:00"}]	f	2025-11-18 15:09:20.238808+00	2025-11-18 15:14:01.201814+00
\.


--
-- Data for Name: user_departments; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.user_departments (id, user_id, department_id, created_at) FROM stdin;
10cc5510-20a3-448f-a7f0-d98dd2fcb07a	ed408400-a5d1-477e-925f-4f525ae810db	2b93eb17-fba0-46d7-ae2b-80ba652faacc	2025-10-29 15:57:12.164746
1b4a376e-529b-49aa-aeb8-1c75a882e706	77d5ac90-58e3-4257-bc55-f04e417a4601	1d0663c9-f914-4ba5-baa8-453a768886f0	2025-10-29 15:57:12.164746
cc371de5-33af-4aa4-8330-79b628303515	77d5ac90-58e3-4257-bc55-f04e417a4601	225609db-adf9-4c55-83fb-5e880dd9481e	2025-10-29 15:57:12.164746
e5cd35e6-2154-418c-a805-8bebd90e8464	77d5ac90-58e3-4257-bc55-f04e417a4601	dc13b32b-cb13-4fef-9d38-79b24f6c6b60	2025-10-29 15:57:12.164746
2786a6a2-c7b9-4895-ad74-5ed80fbd7678	2f5932e3-af2e-413e-8bc4-59113d16a366	1d0663c9-f914-4ba5-baa8-453a768886f0	2025-10-29 15:57:12.164746
90cc7971-5bc5-444b-9f95-59f08567ad5e	2f5932e3-af2e-413e-8bc4-59113d16a366	225609db-adf9-4c55-83fb-5e880dd9481e	2025-10-29 15:57:12.164746
f0bb5df9-e201-4246-8845-f3168d802312	2f5932e3-af2e-413e-8bc4-59113d16a366	dc13b32b-cb13-4fef-9d38-79b24f6c6b60	2025-10-29 15:57:12.164746
2da50371-5e9b-439f-844a-592e34cc02b8	2f5932e3-af2e-413e-8bc4-59113d16a366	2b93eb17-fba0-46d7-ae2b-80ba652faacc	2025-11-07 16:20:56.582269
4416c455-e2a8-426f-bcad-108fdc893e03	77d5ac90-58e3-4257-bc55-f04e417a4601	2b93eb17-fba0-46d7-ae2b-80ba652faacc	2025-11-07 16:25:17.769537
439b683f-98e4-41c5-9ee9-2afd296f0365	5fa24ba5-d4c3-4480-97de-a42f7706c79a	1d0663c9-f914-4ba5-baa8-453a768886f0	2025-11-07 16:34:29.159251
8579a4cb-1c9a-4e83-95b0-fa2eb049a67b	4dd408fa-7666-4d4c-b8e2-251e999f3175	2b93eb17-fba0-46d7-ae2b-80ba652faacc	2025-11-09 23:35:56.56251
3739e8fe-3f79-4c60-bb87-9071a1988ffc	f389b565-0c15-44bd-9748-8fe1ff20bc67	2b93eb17-fba0-46d7-ae2b-80ba652faacc	2025-11-09 23:36:00.671706
4f702748-afea-459f-90ec-9dc984f2f3ce	ba753ca4-bee9-4aab-981e-6fb1ac85b20c	2b93eb17-fba0-46d7-ae2b-80ba652faacc	2025-11-09 23:36:02.06123
50343ab6-ea34-4d0a-b6f0-7aadf5c820cb	cbe8de30-0d7f-4f0b-bb7c-abbd4d6ea192	1d0663c9-f914-4ba5-baa8-453a768886f0	2025-11-09 23:36:51.179984
87754c96-760f-48d3-83ac-821f535da158	8dfb246c-c3ff-411e-aecd-2fa9ef426afe	1d0663c9-f914-4ba5-baa8-453a768886f0	2025-11-09 23:36:53.777663
804cea74-1284-425f-bdc7-7042978fff3b	798b1752-83d0-416c-a097-056328c7d56c	dc13b32b-cb13-4fef-9d38-79b24f6c6b60	2025-11-10 13:21:16.862204
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.user_roles (id, user_id, role_id, created_at, deleted_at, updated_at) FROM stdin;
e7ecda50-1569-4b33-b1b5-5a606a7ec15a	77d5ac90-58e3-4257-bc55-f04e417a4601	1f1abdb0-49a6-4094-98a9-1d2b2847b58b	2025-10-23 16:03:17.368907+00	\N	2025-11-06 12:14:17.069271+00
63ea76c3-1189-40d8-b51a-6b1fb5cffb4e	2f5932e3-af2e-413e-8bc4-59113d16a366	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-23 23:14:03.646879+00	\N	2025-11-06 12:14:17.069271+00
9d566364-f4c8-4566-9d24-b8eaccb55765	4dd408fa-7666-4d4c-b8e2-251e999f3175	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-29 13:23:06.00231+00	\N	2025-11-06 12:14:17.069271+00
69e199b5-f0bf-4184-a42c-3c5b9d115dff	5fa24ba5-d4c3-4480-97de-a42f7706c79a	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-29 13:41:40.563801+00	\N	2025-11-06 12:14:17.069271+00
6c37a99f-2fb9-40a9-868d-3b0b99be6181	798b1752-83d0-416c-a097-056328c7d56c	9788eee0-2f36-4b6f-a942-af2982da0f89	2025-10-29 13:47:09.46524+00	\N	2025-11-06 12:14:17.069271+00
9f8b254f-05ed-4fbf-b401-58a4bef62673	8dfb246c-c3ff-411e-aecd-2fa9ef426afe	9788eee0-2f36-4b6f-a942-af2982da0f89	2025-10-29 14:20:35.436787+00	\N	2025-11-06 12:14:17.069271+00
0137f05c-2137-4dd5-8c02-eb66d06e2b4f	8dfb246c-c3ff-411e-aecd-2fa9ef426afe	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-30 00:22:27.493924+00	\N	2025-11-06 12:14:17.069271+00
3479b4bc-653c-4a62-a11d-37baac7fc779	cbe8de30-0d7f-4f0b-bb7c-abbd4d6ea192	1f1abdb0-49a6-4094-98a9-1d2b2847b58b	2025-10-30 00:33:32.091788+00	\N	2025-11-06 12:14:17.069271+00
bf984c55-b69c-44bf-b3dd-7565e4fed86f	ba753ca4-bee9-4aab-981e-6fb1ac85b20c	9788eee0-2f36-4b6f-a942-af2982da0f89	2025-10-30 00:39:42.206863+00	\N	2025-11-06 12:14:17.069271+00
63d99091-8ea8-48da-b5b2-7c3347fec620	f389b565-0c15-44bd-9748-8fe1ff20bc67	9788eee0-2f36-4b6f-a942-af2982da0f89	2025-10-30 00:43:54.711361+00	\N	2025-11-06 12:14:17.069271+00
950f632d-bea0-4191-9c03-fc0cec4f4343	f389b565-0c15-44bd-9748-8fe1ff20bc67	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-30 00:45:10.473128+00	\N	2025-11-06 12:14:17.069271+00
e1f61e6d-e485-4ca6-a0f1-f46e1c957f99	77d5ac90-58e3-4257-bc55-f04e417a4601	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-30 01:04:59.214753+00	\N	2025-11-06 12:14:17.069271+00
f2bfd697-fe8f-4ab3-8eed-d5c2934b607e	798b1752-83d0-416c-a097-056328c7d56c	bf98d846-8bd5-4739-b146-8c46e174cfec	2025-10-30 01:04:59.214753+00	\N	2025-11-06 12:14:17.069271+00
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.users (id, email, password, first_name, last_name, phone, is_active, created_at, updated_at, deleted_at) FROM stdin;
ed408400-a5d1-477e-925f-4f525ae810db	lauraburgess@example.org	$2b$12$CNbG2XjS6EqhY.NZ64Of1OQ/4TsOKJMmwA/tezz.n/GC9w8rFcI0e	Renee	Salazar	\N	t	2025-10-29 13:25:43.230673	2025-10-29 15:41:40.65201	\N
2f5932e3-af2e-413e-8bc4-59113d16a366	imaad.dean@gmail.com	$2a$14$5CJ7TyAdo/7xj7CKJ9bmYeeo3ukkh7idr9j37q0tq8fStNnn3U95e	imaad	dean	\N	t	2025-10-23 17:55:15.48882	2025-10-29 15:41:40.65201	\N
cbe8de30-0d7f-4f0b-bb7c-abbd4d6ea192	dean@gmail.com	$2a$14$g3h36rDrE50IcQ6Zc.T7..HIaomfQ30UCFtFdXTi9LyqNrp.4oY0a	Muniir	Dean	\N	t	2025-10-30 00:33:30.86607	2025-10-30 00:33:30.86607	\N
4dd408fa-7666-4d4c-b8e2-251e999f3175	kathleenowens@example.org	$2b$12$a4y2f84SdSJXNsGi8OOHFe2NyFgkdt2o848xLX9r9rI1xMZyD1mny	James	Gonzalez	\N	t	2025-10-29 13:23:06.00231	2025-10-29 13:23:06.00231	\N
5fa24ba5-d4c3-4480-97de-a42f7706c79a	hrose@example.org	$2b$12$Lh0sOaFdOs3NRKsRP1ETBOhw3wygmeAwYg/lvdkFDnwMIV1O/SDBe	Nicole	Huff	\N	t	2025-10-29 13:41:40.563801	2025-10-29 13:41:40.563801	\N
798b1752-83d0-416c-a097-056328c7d56c	taylorkimberly@example.org	$2b$12$y5imIm3l.pIxu0Nl5samIOcpPPmksKKT6X4oMCXWX4FJZsu7DxHTq	Adam	Gomez	\N	t	2025-10-29 13:47:09.46524	2025-10-29 13:47:09.46524	\N
8dfb246c-c3ff-411e-aecd-2fa9ef426afe	muniir@gmail.com	$2a$14$CNLlTUAc1S3GQ421HYAq/e5HLTExeGrPEo8NCgKeiHGYFzOHSb9MS	ssebintu	muniir	\N	t	2025-10-29 14:20:34.218775	2025-10-29 14:20:34.218775	\N
f389b565-0c15-44bd-9748-8fe1ff20bc67	mirembe@gmail.com	$2a$14$KhitU/ZsBv2iC1CqNLc.ZePoZ5ruU.tFY0XC/uuKx/Cjag5GtjBiG	Mirembe	Muhsin	\N	t	2025-10-30 00:43:54.106916	2025-10-30 00:43:54.106916	\N
ba753ca4-bee9-4aab-981e-6fb1ac85b20c	muhsin@gmail.com	$2a$10$7Bwy4ykYiQ.wXBfRl9tWpefIPwjnIfnd19JLvEzWvlokph4Xg76QS	Muhsin	Muniir	\N	t	2025-10-30 00:39:42.199884	2025-11-17 11:01:39.287828	\N
77d5ac90-58e3-4257-bc55-f04e417a4601	imaad.ssebintu@gmail.com	$2a$10$QQP48l9exojU/wzyDJZ7L.kRJAGw6q7od5vqe4c7FcVHYwpOh4Osi	imaad	ssebintu	\N	t	2025-10-19 18:45:47.242996	2025-11-20 01:05:36.659251	\N
\.


--
-- Data for Name: vinc; Type: TABLE DATA; Schema: public; Owner: imaad
--

COPY public.vinc (output) FROM stdin;
\.


--
-- Name: academic_years academic_years_name_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT academic_years_name_key UNIQUE (name);


--
-- Name: academic_years academic_years_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.academic_years
    ADD CONSTRAINT academic_years_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: class_papers class_papers_class_id_paper_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_papers
    ADD CONSTRAINT class_papers_class_id_paper_id_key UNIQUE (class_id, paper_id);


--
-- Name: class_papers class_papers_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_papers
    ADD CONSTRAINT class_papers_pkey PRIMARY KEY (id);


--
-- Name: class_promotions class_promotions_from_class_id_academic_year_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_promotions
    ADD CONSTRAINT class_promotions_from_class_id_academic_year_id_key UNIQUE (from_class_id, academic_year_id);


--
-- Name: class_promotions class_promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_promotions
    ADD CONSTRAINT class_promotions_pkey PRIMARY KEY (id);


--
-- Name: class_subjects class_subjects_class_id_subject_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT class_subjects_class_id_subject_id_key UNIQUE (class_id, subject_id);


--
-- Name: class_subjects class_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT class_subjects_pkey PRIMARY KEY (id);


--
-- Name: classes classes_code_unique; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_code_unique UNIQUE (code);


--
-- Name: classes classes_name_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_name_key UNIQUE (name);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: exams exams_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_pkey PRIMARY KEY (id);


--
-- Name: expenses expenses_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_pkey PRIMARY KEY (id);


--
-- Name: fee_type_assignments fee_type_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_type_assignments
    ADD CONSTRAINT fee_type_assignments_pkey PRIMARY KEY (id);


--
-- Name: fee_types fee_types_code_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_types
    ADD CONSTRAINT fee_types_code_key UNIQUE (code);


--
-- Name: fee_types fee_types_name_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_types
    ADD CONSTRAINT fee_types_name_key UNIQUE (name);


--
-- Name: fee_types fee_types_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_types
    ADD CONSTRAINT fee_types_pkey PRIMARY KEY (id);


--
-- Name: fees fees_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_pkey PRIMARY KEY (id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: papers papers_code_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_code_key UNIQUE (code);


--
-- Name: papers papers_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_pkey PRIMARY KEY (id);


--
-- Name: parents parents_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.parents
    ADD CONSTRAINT parents_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_email_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_email_key UNIQUE (email);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_token_key UNIQUE (token);


--
-- Name: payment_allocations payment_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payment_allocations
    ADD CONSTRAINT payment_allocations_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_name_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_key UNIQUE (name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_role_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_permission_id_key UNIQUE (role_id, permission_id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: student_parents student_parents_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.student_parents
    ADD CONSTRAINT student_parents_pkey PRIMARY KEY (id);


--
-- Name: student_parents student_parents_student_id_parent_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.student_parents
    ADD CONSTRAINT student_parents_student_id_parent_id_key UNIQUE (student_id, parent_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: students students_student_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_student_id_key UNIQUE (student_id);


--
-- Name: subjects subjects_code_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_code_key UNIQUE (code);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: teacher_availability teacher_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_availability
    ADD CONSTRAINT teacher_availability_pkey PRIMARY KEY (id);


--
-- Name: teacher_availability teacher_availability_teacher_id_day_of_week_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_availability
    ADD CONSTRAINT teacher_availability_teacher_id_day_of_week_key UNIQUE (teacher_id, day_of_week);


--
-- Name: teacher_subjects teacher_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_pkey PRIMARY KEY (teacher_id, subject_id);


--
-- Name: terms terms_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.terms
    ADD CONSTRAINT terms_pkey PRIMARY KEY (id);


--
-- Name: timetable_entries timetable_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.timetable_entries
    ADD CONSTRAINT timetable_entries_pkey PRIMARY KEY (id);


--
-- Name: timetable_settings timetable_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.timetable_settings
    ADD CONSTRAINT timetable_settings_pkey PRIMARY KEY (id);


--
-- Name: user_departments user_departments_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_pkey PRIMARY KEY (id);


--
-- Name: user_departments user_departments_user_id_department_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_user_id_department_id_key UNIQUE (user_id, department_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_user_id_role_id_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_id_key UNIQUE (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_classes_deleted_at; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_classes_deleted_at ON public.classes USING btree (deleted_at);


--
-- Name: idx_classes_teacher_id; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_classes_teacher_id ON public.classes USING btree (teacher_id);


--
-- Name: idx_fee_types_is_required; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_fee_types_is_required ON public.fee_types USING btree (is_required);


--
-- Name: idx_password_reset_tokens_email; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_password_reset_tokens_email ON public.password_reset_tokens USING btree (email);


--
-- Name: idx_password_reset_tokens_expires_at; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_password_reset_tokens_expires_at ON public.password_reset_tokens USING btree (expires_at);


--
-- Name: idx_password_reset_tokens_token; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_password_reset_tokens_token ON public.password_reset_tokens USING btree (token);


--
-- Name: idx_payment_allocations_fee_id; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_payment_allocations_fee_id ON public.payment_allocations USING btree (fee_id);


--
-- Name: idx_sessions_expires_at; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_sessions_expires_at ON public.sessions USING btree (expires_at);


--
-- Name: idx_sessions_user_id; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_sessions_user_id ON public.sessions USING btree (user_id);


--
-- Name: idx_students_active; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_students_active ON public.students USING btree (is_active);


--
-- Name: idx_students_class_id; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_students_class_id ON public.students USING btree (class_id);


--
-- Name: idx_students_deleted_at; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_students_deleted_at ON public.students USING btree (deleted_at);


--
-- Name: idx_teacher_subjects_paper_id; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_teacher_subjects_paper_id ON public.teacher_subjects USING btree (paper_id);


--
-- Name: idx_teacher_subjects_teacher_subject_paper; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_teacher_subjects_teacher_subject_paper ON public.teacher_subjects USING btree (teacher_id, subject_id, paper_id);


--
-- Name: idx_users_deleted_at; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_users_deleted_at ON public.users USING btree (deleted_at);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: imaad
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: academic_years update_academic_years_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_academic_years_updated_at BEFORE UPDATE ON public.academic_years FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: attendance update_attendance_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_attendance_updated_at BEFORE UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: categories update_categories_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON public.categories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: class_papers update_class_papers_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_class_papers_updated_at BEFORE UPDATE ON public.class_papers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: class_promotions update_class_promotions_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_class_promotions_updated_at BEFORE UPDATE ON public.class_promotions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: classes update_classes_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_classes_updated_at BEFORE UPDATE ON public.classes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: departments update_departments_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: exams update_exams_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_exams_updated_at BEFORE UPDATE ON public.exams FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: expenses update_expenses_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON public.expenses FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: fee_types update_fee_types_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_fee_types_updated_at BEFORE UPDATE ON public.fee_types FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: fees update_fees_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_fees_updated_at BEFORE UPDATE ON public.fees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: grades update_grades_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_grades_updated_at BEFORE UPDATE ON public.grades FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: notifications update_notifications_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON public.notifications FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: papers update_papers_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_papers_updated_at BEFORE UPDATE ON public.papers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: parents update_parents_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_parents_updated_at BEFORE UPDATE ON public.parents FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: payment_allocations update_payment_allocations_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_payment_allocations_updated_at BEFORE UPDATE ON public.payment_allocations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: payments update_payments_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON public.payments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: results update_results_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_results_updated_at BEFORE UPDATE ON public.results FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: roles update_roles_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON public.roles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: schedules update_schedules_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_schedules_updated_at BEFORE UPDATE ON public.schedules FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: student_parents update_student_parents_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_student_parents_updated_at BEFORE UPDATE ON public.student_parents FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: students update_students_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_students_updated_at BEFORE UPDATE ON public.students FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subjects update_subjects_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_subjects_updated_at BEFORE UPDATE ON public.subjects FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: terms update_terms_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_terms_updated_at BEFORE UPDATE ON public.terms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: imaad
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: attendance attendance_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: attendance attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: class_papers class_papers_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_papers
    ADD CONSTRAINT class_papers_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_papers class_papers_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_papers
    ADD CONSTRAINT class_papers_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES public.papers(id) ON DELETE CASCADE;


--
-- Name: class_papers class_papers_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_papers
    ADD CONSTRAINT class_papers_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: class_promotions class_promotions_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_promotions
    ADD CONSTRAINT class_promotions_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: class_promotions class_promotions_from_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_promotions
    ADD CONSTRAINT class_promotions_from_class_id_fkey FOREIGN KEY (from_class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_promotions class_promotions_to_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_promotions
    ADD CONSTRAINT class_promotions_to_class_id_fkey FOREIGN KEY (to_class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_subjects class_subjects_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT class_subjects_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: class_subjects class_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.class_subjects
    ADD CONSTRAINT class_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: departments departments_assistant_head_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_assistant_head_id_fkey FOREIGN KEY (assistant_head_id) REFERENCES public.users(id);


--
-- Name: departments departments_head_of_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_head_of_department_id_fkey FOREIGN KEY (head_of_department_id) REFERENCES public.users(id);


--
-- Name: exams exams_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: exams exams_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: exams exams_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES public.papers(id) ON DELETE CASCADE;


--
-- Name: exams exams_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.exams
    ADD CONSTRAINT exams_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: expenses expenses_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.expenses
    ADD CONSTRAINT expenses_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: fee_type_assignments fee_type_assignments_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_type_assignments
    ADD CONSTRAINT fee_type_assignments_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: fee_type_assignments fee_type_assignments_fee_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_type_assignments
    ADD CONSTRAINT fee_type_assignments_fee_type_id_fkey FOREIGN KEY (fee_type_id) REFERENCES public.fee_types(id) ON DELETE CASCADE;


--
-- Name: fee_type_assignments fee_type_assignments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fee_type_assignments
    ADD CONSTRAINT fee_type_assignments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: fees fees_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id);


--
-- Name: fees fees_fee_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_fee_type_id_fkey FOREIGN KEY (fee_type_id) REFERENCES public.fee_types(id) ON DELETE CASCADE;


--
-- Name: fees fees_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: fees fees_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.fees
    ADD CONSTRAINT fees_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.terms(id);


--
-- Name: classes fk_classes_teacher_id; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT fk_classes_teacher_id FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: students fk_students_class_id; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_class_id FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: papers papers_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.papers
    ADD CONSTRAINT papers_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: payment_allocations payment_allocations_fee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payment_allocations
    ADD CONSTRAINT payment_allocations_fee_id_fkey FOREIGN KEY (fee_id) REFERENCES public.fees(id);


--
-- Name: payment_allocations payment_allocations_fee_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payment_allocations
    ADD CONSTRAINT payment_allocations_fee_type_id_fkey FOREIGN KEY (fee_type_id) REFERENCES public.fee_types(id) ON DELETE CASCADE;


--
-- Name: payment_allocations payment_allocations_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payment_allocations
    ADD CONSTRAINT payment_allocations_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE CASCADE;


--
-- Name: payments payments_paid_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_paid_by_fkey FOREIGN KEY (paid_by) REFERENCES public.users(id);


--
-- Name: payments payments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: results results_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exams(id) ON DELETE CASCADE;


--
-- Name: results results_grade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_grade_id_fkey FOREIGN KEY (grade_id) REFERENCES public.grades(id);


--
-- Name: results results_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES public.papers(id) ON DELETE CASCADE;


--
-- Name: results results_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: schedules schedules_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: schedules schedules_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: schedules schedules_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: student_parents student_parents_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.student_parents
    ADD CONSTRAINT student_parents_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.parents(id) ON DELETE CASCADE;


--
-- Name: student_parents student_parents_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.student_parents
    ADD CONSTRAINT student_parents_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: subjects subjects_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: teacher_availability teacher_availability_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_availability
    ADD CONSTRAINT teacher_availability_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: teacher_subjects teacher_subjects_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES public.papers(id);


--
-- Name: teacher_subjects teacher_subjects_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: teacher_subjects teacher_subjects_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.teacher_subjects
    ADD CONSTRAINT teacher_subjects_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: terms terms_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.terms
    ADD CONSTRAINT terms_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(id) ON DELETE CASCADE;


--
-- Name: timetable_entries timetable_entries_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.timetable_entries
    ADD CONSTRAINT timetable_entries_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id) ON DELETE CASCADE;


--
-- Name: timetable_entries timetable_entries_paper_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.timetable_entries
    ADD CONSTRAINT timetable_entries_paper_id_fkey FOREIGN KEY (paper_id) REFERENCES public.papers(id) ON DELETE SET NULL;


--
-- Name: timetable_entries timetable_entries_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.timetable_entries
    ADD CONSTRAINT timetable_entries_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON DELETE CASCADE;


--
-- Name: timetable_entries timetable_entries_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.timetable_entries
    ADD CONSTRAINT timetable_entries_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_departments user_departments_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE CASCADE;


--
-- Name: user_departments user_departments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_departments
    ADD CONSTRAINT user_departments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imaad
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict QWQEcThPpIzf4j8Kckdr6fV7IYyOJuTUjjnMxjARkCLrZ6o3D4nTdyy3DbCJyBe

