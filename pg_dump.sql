PGDMP     (    6            
    z            sneaker_factory    15.0    15.0     V           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            W           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            X           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            Y           1262    16398    sneaker_factory    DATABASE     �   CREATE DATABASE sneaker_factory WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE sneaker_factory;
                postgres    false            S          0    16557    __EFMigrationsHistory 
   TABLE DATA           R   COPY public."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
    public          postgres    false    228   �       F          0    16423    available_clients 
   TABLE DATA           �   COPY public.available_clients (client_id, first_name, second_name, organisation_name, phone, email, address, contract_id) FROM stdin;
    public          postgres    false    215          E          0    16418    clients 
   TABLE DATA           o   COPY public.clients (client_id, first_name, second_name, organisation_name, phone, email, address) FROM stdin;
    public          postgres    false    214   m       I          0    16430 	   contracts 
   TABLE DATA           \   COPY public.contracts (contract_id, client_id, sneaker_id, sign_date, deadline) FROM stdin;
    public          postgres    false    218   �       K          0    16434    employee 
   TABLE DATA           �   COPY public.employee (employee_id, first_name, second_name, father_name, phone, email, address, factory_role, login, password, salt_pass, hired) FROM stdin;
    public          postgres    false    220   �       M          0    16440    jobs 
   TABLE DATA           �   COPY public.jobs (job_id, creator_empl_id, executor_empl_id, contr_id, description, created, deadline, prior, completed) FROM stdin;
    public          postgres    false    222   �       O          0    16447    potential_clients 
   TABLE DATA           �   COPY public.potential_clients (client_id, first_name, second_name, organisation_name, phone, email, address, meeting) FROM stdin;
    public          postgres    false    224   �       Q          0    16453    sneakers 
   TABLE DATA           T   COPY public.sneakers (sneaker_id, model, weight, size, arrived, leaved) FROM stdin;
    public          postgres    false    226   �       Z           0    0    available_clients_client_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.available_clients_client_id_seq', 15, true);
          public          postgres    false    216            [           0    0    clients_client_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.clients_client_id_seq', 1, false);
          public          postgres    false    217            \           0    0    contracts_contract_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.contracts_contract_id_seq', 165, true);
          public          postgres    false    219            ]           0    0    employee_employee_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.employee_employee_id_seq', 7, true);
          public          postgres    false    221            ^           0    0    jobs_job_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.jobs_job_id_seq', 15, true);
          public          postgres    false    223            _           0    0    potential_clients_client_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.potential_clients_client_id_seq', 15, true);
          public          postgres    false    225            `           0    0    sneakers_sneaker_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.sneakers_sneaker_id_seq', 3, true);
          public          postgres    false    227            S   Z   x�32022406044001���,Ju�-�qI,I�4�3�34�2B(141�wIMK,�)�L)���Tjb``dY����\��d\� NO�      F   W  x�e�?O�@��맸0i�M�P
�ŉ\X�z���3M�P5FLH����@�
�}#�vp1�K.��ܛ��:�c��Xc�Z�	^0�|ab���Bf��kNe�o��M��u�@v��8�J��k����W#�`���[LIxP#
��8{#�˒x���x����j��z��Є"w<�,�f�0興]�Qԓ1�_��d'�Q�4�u��:�������*�A�6��R��I7��fо��A[$z=���e7�e��L&��l��@�\�~"y3~G$�P5(g��aUJ�l�=Ӥ��$��KM3���z�Ͼ@J�ˌ=��;�$F��#���9Ň�Mc�y�l���eh����r      E      x������ � �      I   Y   x�m��� C��L6 g��a�_�
����=��Phd�������nX	���r���_��3#J��>��N����hVe:���,i      K   �  x��T�n�J]�|��h������/	�n6��v��$#���,@]b���yH	!���Q�	y��ew�����9e`�C������N>��,ʻ�{��}N�)���I>��3��=����0�ơ�l��i���q&k,���h��|������mA��|Ry���R��U��������W���y��%��½P�{7�����[U�<Xi�����U�Κ LL���$}ЂC��Ԯ�*ՕSuL�꺖�-7�mϐ#���/@��*�	�C�h�͘�M�ds�ڰ�}v
��/���6Gi�f��6YO�K+CY���f1�(��i�ϊYI'[ܚ�����$���i*؝{�=�0jV��)��`S�!i%�*�;�ޛ$E2^qt�t���:��<X���M���\�}���J;훅j,���n> 9:o�tɹ��!AR��A����p��w�&c���-Ie���w�]m�P�
E]G�V�����+���q�:�^Y.�_/a���(FO��եf}c.�²�����)Q>#ʧ��||��O��4s�+�_*����y��7��+6J�
��,�#1�<p<Y�4I��� �."0%@��. DZ��.@��E�t���{��C�����'$���e�	����T5�&��V&��q����Y<�X��=ՠ�ĕ)��l��,�к��2�Z�&�)Z%��� m%p��� F�V��$c���ț�^'�+I#moX�z������      M   �  x�uS�N�@>;O���v��'$�U%�\"08*����F¡HIA�z�Z!������
�o�o�IL�����3��ό�%-ߝ8�gq��=by�:����l;K��^�5�$Y����e�n��%%�~����x���6R�f*�&�,�Ե>U��N��B=��ş�t@p;I�q�s��И�#?�c���'�s=Bc���o�#aG�䞍O����e'����ݏ;y����� =fY��$q?>Γ����`�<y#�N$$����-7S�x���G���Ym�Uߡ�V���ԳQ�[-�1S=bzD���gF5ݟ���3u��!��`�zA��!�S��**��Ջ��:	ݸo�R�E�xV�R�8�B�p��%�J꡾D_Q%���<@�Θ�o�\O���m�@��s=����%�k��������$"�[H��UW��Y��H,���nM4#��Q��0��"1͑��~�Ĕa���C�����sYG��g��������<�N9��z�R����쿠I �y�z�+ͦ믆�CE���a7�!{�ܔ�jk�h̔Kh-�R��\:��,-;����s��2�Ex���8vC�k7�J�P������N��j���s1b��U|MʬtMj�������`���c�-Y�!�h�ACz`��XIޯ�|&��"�����juӃn������F�/r'2�      O   $  x�U��J�@�ד���L��t����+A��ছ�l�iJҨ����s-B}Z�E�7o�?�\Μ����༺�O������o�(��#>����%~�𽺭n̸$�xA�S�y �0�U���5��K'�	NM��{�c�+��z����TX���p��p�]��6��.�eq���
�$�� �!�M�6�mʀd� �L�}����%1i�҃�"�z���L_��<�h��c�M`?��tA�\*m�JQ�1`����)�nˌ���(gg%��X���,�"      Q   �   x�}�;
1E�Ud	d�v��4"v�0� �q���`�[xّ#Z����9���������U���.V���6ZF���<-�9y҂�"sBM��cX������f�W
���~��J�7(����K�jR`���J���s���D=     