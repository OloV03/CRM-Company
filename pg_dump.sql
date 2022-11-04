PGDMP     9                
    z            sneaker_factory    15.0    15.0 C    U           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            V           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            W           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            X           1262    16398    sneaker_factory    DATABASE     �   CREATE DATABASE sneaker_factory WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE sneaker_factory;
                postgres    false            _           1247    16400    priority    TYPE     M   CREATE TYPE public.priority AS ENUM (
    'low',
    'medium',
    'high'
);
    DROP TYPE public.priority;
       public          postgres    false            �            1255    16407 P   get_count_completed(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     �  CREATE FUNCTION public.get_count_completed(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone) RETURNS integer
    LANGUAGE sql
    AS $$
	SELECT count(*) FROM jobs
	WHERE ((emp_id = executor_empl_id)
			AND (startDate <= created) AND (endDate >= created)
			AND (startDate <= completed) and (endDate >= completed)
			AND (completed <= deadline));
$$;
 �   DROP FUNCTION public.get_count_completed(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone);
       public          postgres    false            �            1255    16408 M   get_count_inwork(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     S  CREATE FUNCTION public.get_count_inwork(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone) RETURNS integer
    LANGUAGE sql
    AS $$
	SELECT count(*) FROM jobs
	WHERE ((emp_id = executor_empl_id)
			AND (startDate <= created) AND (endDate >= created)
			AND (completed = NULL) AND NOW() < deadline)
$$;
 }   DROP FUNCTION public.get_count_inwork(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone);
       public          postgres    false            �            1255    16409 R   get_count_nocompleted(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     X  CREATE FUNCTION public.get_count_nocompleted(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone) RETURNS integer
    LANGUAGE sql
    AS $$
	SELECT count(*) FROM jobs
	WHERE ((emp_id = executor_empl_id)
			AND (startDate <= created) AND (endDate >= created)
			AND (completed = NULL) AND NOW() > deadline)
$$;
 �   DROP FUNCTION public.get_count_nocompleted(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone);
       public          postgres    false            �            1255    16410 L   get_count_tasks(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     $  CREATE FUNCTION public.get_count_tasks(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone) RETURNS integer
    LANGUAGE sql
    AS $$
	SELECT count(*) FROM jobs
	WHERE ((emp_id = executor_empl_id)
			AND (startDate <= created) AND (endDate >= created));
$$;
 |   DROP FUNCTION public.get_count_tasks(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone);
       public          postgres    false            �            1255    16411 Z   get_count_сompleted_faildate(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     �  CREATE FUNCTION public."get_count_сompleted_faildate"(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone) RETURNS integer
    LANGUAGE sql
    AS $$
	SELECT count(*) FROM jobs
	WHERE ((emp_id = executor_empl_id)
			AND (startDate <= created) AND (endDate >= created)
			AND (startDate <= completed) AND (endDate <= completed)
			AND (completed > deadline))
$$;
 �   DROP FUNCTION public."get_count_сompleted_faildate"(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone);
       public          postgres    false            �            1255    16412    get_jobs_json()    FUNCTION     �   CREATE FUNCTION public.get_jobs_json() RETURNS TABLE(j json)
    LANGUAGE sql
    AS $$
        SELECT json_agg(jo) FROM (SELECT * FROM jobs) AS jo;
    $$;
 &   DROP FUNCTION public.get_jobs_json();
       public          postgres    false            �            1255    16413 G   get_report(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     A  CREATE FUNCTION public.get_report(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone) RETURNS TABLE(employeeid integer, alltasks integer, intimecompeted integer, nonintimecompleted integer, failedtasks integer, inworktasks integer)
    LANGUAGE sql
    AS $$
	SELECT emp_id,
			get_count_tasks(emp_id, startDate, endDate),
			get_count_completed(emp_id, startDate, endDate),
			get_count_сompleted_failDate(emp_id, startDate, endDate),
			get_count_noCompleted(emp_id, startDate, endDate),
			get_count_inWork(emp_id, startDate, endDate)
$$;
 w   DROP FUNCTION public.get_report(emp_id integer, startdate timestamp with time zone, enddate timestamp with time zone);
       public          postgres    false            �            1255    16564    get_reports()    FUNCTION     �  CREATE FUNCTION public.get_reports() RETURNS TABLE(employeeid integer, alltasks integer, intimecompeted integer, nonintimecompleted integer, failedtasks integer, inworktasks integer)
    LANGUAGE plpgsql
    AS $$
	
DECLARE
	empId integer;
	startDate timestamp = (SELECT MIN(created) FROM jobs);
	endDate timestamp = (SELECT MAX(created) FROM jobs);
BEGIN
	
	FOR empId IN (SELECT employee_id FROM employee) LOOP
		RETURN QUERY SELECT * FROM get_report(empId, startDate, endDate);
	END LOOP;
	RETURN;
END;

$$;
 $   DROP FUNCTION public.get_reports();
       public          postgres    false            �            1255    16414    remove_all_jobs_after_year()    FUNCTION     �   CREATE FUNCTION public.remove_all_jobs_after_year() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM jobs WHERE current_timestamp >= jobs.deadline + make_interval(years := 1);
    END;
    $$;
 3   DROP FUNCTION public.remove_all_jobs_after_year();
       public          postgres    false            �            1255    16415    send_jobs_json_linux()    FUNCTION     �   CREATE FUNCTION public.send_jobs_json_linux() RETURNS void
    LANGUAGE sql
    AS $$
        COPY(SELECT get_jobs_json()) TO '/var/lib/postgresql/jobs.json';
    $$;
 -   DROP FUNCTION public.send_jobs_json_linux();
       public          postgres    false            �            1255    16416 H   send_report(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     ;  CREATE FUNCTION public.send_report(integer, timestamp with time zone, timestamp with time zone) RETURNS void
    LANGUAGE sql
    AS $_$
CREATE TEMP TABLE table_report ON COMMIT DROP
AS
SELECT * FROM get_report($1, $2, $3);
COPY (SELECT * FROM table_report) TO E'/home/dmitry/Documents/report.csv' CSV HEADER;
$_$;
 _   DROP FUNCTION public.send_report(integer, timestamp with time zone, timestamp with time zone);
       public          postgres    false            �            1255    16417 N   send_report_linux(integer, timestamp with time zone, timestamp with time zone)    FUNCTION     >  CREATE FUNCTION public.send_report_linux(integer, timestamp with time zone, timestamp with time zone) RETURNS void
    LANGUAGE sql
    AS $_$
CREATE TEMP TABLE table_report ON COMMIT DROP
AS
SELECT * FROM get_report($1, $2, $3);
COPY (SELECT * FROM table_report) TO E'/var/lib/postgresql/report.csv' CSV HEADER;
$_$;
 e   DROP FUNCTION public.send_report_linux(integer, timestamp with time zone, timestamp with time zone);
       public          postgres    false            �            1259    16557    __EFMigrationsHistory    TABLE     �   CREATE TABLE public."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32) NOT NULL
);
 +   DROP TABLE public."__EFMigrationsHistory";
       public         heap    postgres    false            �            1259    16418    clients    TABLE     �   CREATE TABLE public.clients (
    client_id integer NOT NULL,
    first_name character varying(15),
    second_name character varying(15),
    organisation_name text NOT NULL,
    phone text,
    email text,
    address text
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �            1259    16423    available_clients    TABLE     ]   CREATE TABLE public.available_clients (
    contract_id integer
)
INHERITS (public.clients);
 %   DROP TABLE public.available_clients;
       public         heap    postgres    false    214            �            1259    16428    available_clients_client_id_seq    SEQUENCE     �   ALTER TABLE public.available_clients ALTER COLUMN client_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.available_clients_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    215            �            1259    16429    clients_client_id_seq    SEQUENCE     �   ALTER TABLE public.clients ALTER COLUMN client_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.clients_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    214            �            1259    16430 	   contracts    TABLE     �   CREATE TABLE public.contracts (
    contract_id integer NOT NULL,
    client_id integer NOT NULL,
    sneaker_id integer NOT NULL,
    sign_date timestamp without time zone NOT NULL,
    deadline timestamp without time zone
);
    DROP TABLE public.contracts;
       public         heap    postgres    false            �            1259    16433    contracts_contract_id_seq    SEQUENCE     �   ALTER TABLE public.contracts ALTER COLUMN contract_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contracts_contract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    218            �            1259    16434    employee    TABLE     �  CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    first_name character varying(15) NOT NULL,
    second_name character varying(15) NOT NULL,
    father_name character varying(15),
    phone text,
    email text,
    address text,
    factory_role character varying(30),
    login character varying(50),
    password bytea,
    salt_pass text,
    hired timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.employee;
       public         heap    postgres    false            �            1259    16439    employee_employee_id_seq    SEQUENCE     �   ALTER TABLE public.employee ALTER COLUMN employee_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.employee_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    220            �            1259    16440    jobs    TABLE     �  CREATE TABLE public.jobs (
    job_id integer NOT NULL,
    creator_empl_id integer NOT NULL,
    executor_empl_id integer NOT NULL,
    contr_id integer,
    description text NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deadline timestamp without time zone NOT NULL,
    prior public.priority NOT NULL,
    completed timestamp without time zone
);
    DROP TABLE public.jobs;
       public         heap    postgres    false    863            �            1259    16446    jobs_job_id_seq    SEQUENCE     �   ALTER TABLE public.jobs ALTER COLUMN job_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.jobs_job_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    222            �            1259    16447    potential_clients    TABLE     m   CREATE TABLE public.potential_clients (
    meeting timestamp without time zone
)
INHERITS (public.clients);
 %   DROP TABLE public.potential_clients;
       public         heap    postgres    false    214            �            1259    16452    potential_clients_client_id_seq    SEQUENCE     �   ALTER TABLE public.potential_clients ALTER COLUMN client_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.potential_clients_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    224            �            1259    16453    sneakers    TABLE     �   CREATE TABLE public.sneakers (
    sneaker_id integer NOT NULL,
    model text,
    weight numeric(5,2),
    size character varying(4),
    arrived timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    leaved timestamp without time zone
);
    DROP TABLE public.sneakers;
       public         heap    postgres    false            �            1259    16459    sneakers_sneaker_id_seq    SEQUENCE     �   ALTER TABLE public.sneakers ALTER COLUMN sneaker_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sneakers_sneaker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    226            R          0    16557    __EFMigrationsHistory 
   TABLE DATA           R   COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
    public          postgres    false    228   �`       E          0    16423    available_clients 
   TABLE DATA           �   COPY public.available_clients (client_id, first_name, second_name, organisation_name, phone, email, address, contract_id) FROM stdin;
    public          postgres    false    215   a       D          0    16418    clients 
   TABLE DATA           o   COPY public.clients (client_id, first_name, second_name, organisation_name, phone, email, address) FROM stdin;
    public          postgres    false    214   lb       H          0    16430 	   contracts 
   TABLE DATA           \   COPY public.contracts (contract_id, client_id, sneaker_id, sign_date, deadline) FROM stdin;
    public          postgres    false    218   �b       J          0    16434    employee 
   TABLE DATA           �   COPY public.employee (employee_id, first_name, second_name, father_name, phone, email, address, factory_role, login, password, salt_pass, hired) FROM stdin;
    public          postgres    false    220   �b       L          0    16440    jobs 
   TABLE DATA           �   COPY public.jobs (job_id, creator_empl_id, executor_empl_id, contr_id, description, created, deadline, prior, completed) FROM stdin;
    public          postgres    false    222   �e       N          0    16447    potential_clients 
   TABLE DATA           �   COPY public.potential_clients (client_id, first_name, second_name, organisation_name, phone, email, address, meeting) FROM stdin;
    public          postgres    false    224   �h       P          0    16453    sneakers 
   TABLE DATA           T   COPY public.sneakers (sneaker_id, model, weight, size, arrived, leaved) FROM stdin;
    public          postgres    false    226   �i       Y           0    0    available_clients_client_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.available_clients_client_id_seq', 15, true);
          public          postgres    false    216            Z           0    0    clients_client_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.clients_client_id_seq', 1, false);
          public          postgres    false    217            [           0    0    contracts_contract_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.contracts_contract_id_seq', 165, true);
          public          postgres    false    219            \           0    0    employee_employee_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.employee_employee_id_seq', 7, true);
          public          postgres    false    221            ]           0    0    jobs_job_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.jobs_job_id_seq', 12, true);
          public          postgres    false    223            ^           0    0    potential_clients_client_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.potential_clients_client_id_seq', 15, true);
          public          postgres    false    225            _           0    0    sneakers_sneaker_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.sneakers_sneaker_id_seq', 3, true);
          public          postgres    false    227            �           2606    16561 .   __EFMigrationsHistory PK___EFMigrationsHistory 
   CONSTRAINT     {   ALTER TABLE ONLY public."__EFMigrationsHistory"
    ADD CONSTRAINT "PK___EFMigrationsHistory" PRIMARY KEY ("MigrationId");
 \   ALTER TABLE ONLY public."__EFMigrationsHistory" DROP CONSTRAINT "PK___EFMigrationsHistory";
       public            postgres    false    228            �           2606    16461 (   available_clients available_clients_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.available_clients
    ADD CONSTRAINT available_clients_pkey PRIMARY KEY (client_id);
 R   ALTER TABLE ONLY public.available_clients DROP CONSTRAINT available_clients_pkey;
       public            postgres    false    215            �           2606    16463    clients clients_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pk UNIQUE (client_id);
 <   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pk;
       public            postgres    false    214            �           2606    16465    clients clients_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    214            �           2606    16467    contracts contracts_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (contract_id);
 B   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_pkey;
       public            postgres    false    218            �           2606    16469    employee employee_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public            postgres    false    220            �           2606    16471    jobs jobs_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (job_id);
 8   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_pkey;
       public            postgres    false    222            �           2606    16473 (   potential_clients potential_clients_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.potential_clients
    ADD CONSTRAINT potential_clients_pkey PRIMARY KEY (client_id);
 R   ALTER TABLE ONLY public.potential_clients DROP CONSTRAINT potential_clients_pkey;
       public            postgres    false    224            �           2606    16475    sneakers sneakers_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.sneakers
    ADD CONSTRAINT sneakers_pkey PRIMARY KEY (sneaker_id);
 @   ALTER TABLE ONLY public.sneakers DROP CONSTRAINT sneakers_pkey;
       public            postgres    false    226            �           1259    16476    client_address_index    INDEX     K   CREATE INDEX client_address_index ON public.clients USING btree (address);
 (   DROP INDEX public.client_address_index;
       public            postgres    false    214            �           1259    16477    client_name_index    INDEX     K   CREATE INDEX client_name_index ON public.clients USING btree (first_name);
 %   DROP INDEX public.client_name_index;
       public            postgres    false    214            �           1259    16478    client_org_name_index    INDEX     V   CREATE INDEX client_org_name_index ON public.clients USING btree (organisation_name);
 )   DROP INDEX public.client_org_name_index;
       public            postgres    false    214            �           2620    16479    jobs one_year_ttl    TRIGGER     �   CREATE TRIGGER one_year_ttl AFTER INSERT OR UPDATE ON public.jobs FOR EACH STATEMENT EXECUTE FUNCTION public.remove_all_jobs_after_year();
 *   DROP TRIGGER one_year_ttl ON public.jobs;
       public          postgres    false    236    222            �           2606    16480 %   available_clients contract_ref_constr    FK CONSTRAINT     �   ALTER TABLE ONLY public.available_clients
    ADD CONSTRAINT contract_ref_constr FOREIGN KEY (contract_id) REFERENCES public.contracts(contract_id);
 O   ALTER TABLE ONLY public.available_clients DROP CONSTRAINT contract_ref_constr;
       public          postgres    false    215    3235    218            �           2606    16485 "   contracts contracts_client_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.available_clients(client_id);
 L   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_client_id_fkey;
       public          postgres    false    3233    215    218            �           2606    16490 #   contracts contracts_sneaker_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_sneaker_id_fkey FOREIGN KEY (sneaker_id) REFERENCES public.sneakers(sneaker_id);
 M   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_sneaker_id_fkey;
       public          postgres    false    226    218    3243            �           2606    16495    jobs jobs_contr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_contr_id_fkey FOREIGN KEY (contr_id) REFERENCES public.contracts(contract_id);
 A   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_contr_id_fkey;
       public          postgres    false    222    3235    218            �           2606    16500    jobs jobs_creator_empl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_creator_empl_id_fkey FOREIGN KEY (creator_empl_id) REFERENCES public.employee(employee_id);
 H   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_creator_empl_id_fkey;
       public          postgres    false    220    222    3237            �           2606    16505    jobs jobs_executor_empl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_executor_empl_id_fkey FOREIGN KEY (executor_empl_id) REFERENCES public.employee(employee_id);
 I   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_executor_empl_id_fkey;
       public          postgres    false    222    3237    220            C           0    16440    jobs    ROW SECURITY     2   ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;          public          postgres    false    222            R   Z   x�32022406044001���,Ju�-�qI,I�4�3�34�2B(141�wIMK,�)�L)���Tjb``dY����\��d\� NO�      E   W  x�e�?O�@��맸0i�M�P
�ŉ\X�z���3M�P5FLH����@�
�}#�vp1�K.��ܛ��:�c��Xc�Z�	^0�|ab���Bf��kNe�o��M��u�@v��8�J��k����W#�`���[LIxP#
��8{#�˒x���x����j��z��Є"w<�,�f�0興]�Qԓ1�_��d'�Q�4�u��:�������*�A�6��R��I7��fо��A[$z=���e7�e��L&��l��@�\�~"y3~G$�P5(g��aUJ�l�=Ӥ��$��KM3���z�Ͼ@J�ˌ=��;�$F��#���9Ň�Mc�y�l���eh����r      D      x������ � �      H   Y   x�m��� C��L6 g��a�_�
����=��Phd�������nX	���r���_��3#J��>��N����hVe:���,i      J   �  x��T�n�J]�|��h������/	�n6��v��$#���,@]b���yH	!���Q�	y��ew�����9e`�C������N>��,ʻ�{��}N�)���I>��3��=����0�ơ�l��i���q&k,���h��|������mA��|Ry���R��U��������W���y��%��½P�{7�����[U�<Xi�����U�Κ LL���$}ЂC��Ԯ�*ՕSuL�꺖�-7�mϐ#���/@��*�	�C�h�͘�M�ds�ڰ�}v
��/���6Gi�f��6YO�K+CY���f1�(��i�ϊYI'[ܚ�����$���i*؝{�=�0jV��)��`S�!i%�*�;�ޛ$E2^qt�t���:��<X���M���\�}���J;훅j,���n> 9:o�tɹ��!AR��A����p��w�&c���-Ie���w�]m�P�
E]G�V�����+���q�:�^Y.�_/a���(FO��եf}c.�²�����)Q>#ʧ��||��O��4s�+�_*����y��7��+6J�
��,�#1�<p<Y�4I��� �."0%@��. DZ��.@��E�t���{��C�����'$���e�	����T5�&��V&��q����Y<�X��=ՠ�ĕ)��l��,�к��2�Z�&�)Z%��� m%p��� F�V��$c���ț�^'�+I#moX�z������      L   �  x�uS�N�@];_1�X3���^!��*�e�K���
i;EJ
��E�
���Iy���_��G=w&Ĥ�qb]�̝��)O���z{"�:b���^�m?��{���`���s7�zZjݐIC)����2���pJ֡vg�������]����т�٧��w�t����f��=�	���1��rnFh,����5��T�4T~��-��%r���&T(��~�d���HŻ�/��Y?;��n�ˎ7�9�W���R�:�q3~	i�u����.�&^�m0-}��k*�.�Ѻ�M�f,haFx���n�u�ϧ�?����h��DGO�	�s^O��ꑞ�Ĝ�N��s�.5��Ļ���v����vP��.4Cs���S���;���{��Wsf&�N��1��n���L\4J5�M-Pi���jF�1��~���*�KsZw{߳�񲆣k[�X#���be���p"f�92�o��r"?CNwh�#��v.ױ5Ι{�]`�ҏ��à���G5t�VV~��	��$
��<N���*{������(���K��=^��[wj�h�Kx-_K7|DQ��l褒j��/ �����+�蒾�O�ŉ.*I|8w�>�v��XnbN���Y���}�l����R%A�R��������V����"�      N   $  x�U��J�@�ד���L��t����+A��ছ�l�iJҨ����s-B}Z�E�7o�?�\Μ����༺�O������o�(��#>����%~�𽺭n̸$�xA�S�y �0�U���5��K'�	NM��{�c�+��z����TX���p��p�]��6��.�eq���
�$�� �!�M�6�mʀd� �L�}����%1i�҃�"�z���L_��<�h��c�M`?��tA�\*m�JQ�1`����)�nˌ���(gg%��X���,�"      P   �   x�}�;
1E�Ud	d�v��4"v�0� �q���`�[xّ#Z����9���������U���.V���6ZF���<-�9y҂�"sBM��cX������f�W
���~��J�7(����K�jR`���J���s���D=     