PGDMP                          x            tesis    10.10    10.10                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false                      0    24703 
   asignacion 
   TABLE DATA               O   COPY public.asignacion (fecha, hora, cod_usuario, cod_publicacion) FROM stdin;
    public       postgres    false    200   �                 0    24695    publicacion 
   TABLE DATA               �   COPY public.publicacion (cod_publicacion, tipo, nombre, descripcion, posicion_x, posicion_y, estado, subtipo, fechahora) FROM stdin;
    public       postgres    false    199                     0    24682    usuario 
   TABLE DATA               S   COPY public.usuario (cod_usuario, cui, nombre, password, tipo, estado) FROM stdin;
    public       postgres    false    197   J	                  0    0    publicacion_cod_publicacion_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public.publicacion_cod_publicacion_seq', 159, true);
            public       postgres    false    198                       0    0    usuario_cod_usuario_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.usuario_cod_usuario_seq', 209, true);
            public       postgres    false    196               c   x�Uλ� E�ax��`��#n�rG��{v:;y��]v~�м���i�J��
T!A�Ѐ&���Z��EhZ��EhZ���WhBq���3�K�         $  x���ˎ�  е�|�$�m<�vV#��,�]7$�G~$����/�NF��rl�;�Yr�y\�ӄ$Z����Z�t�'���x2�M�m�4z3�,ʭ��+�Vo2�4r���>�i�+;�ۿ^���5_�l���z[�:h;tp8�\�Ɯ��\��d:?��_͙���f�+}�-4���ׂ��=ޏ'��$�T�욒e�WB2�d��Jx(&ْ�%���G!1^b� B�ª�c�I�� ]���i�|&���,���0�ֶ����Ӧ���m�(V�d�����d���X B�SV�JA��)�S�(��nx�ޫ��T1֋�y�*�A�|�`���G�YG1���_��>==��c.��*|����n�Ȩ3����8"υ'�<c{>�p��1�����|*�" ���|���x��f�ln<��e]ֱ��d���gH�%�0r���.��.{w��*vv��b�8l���h6ՌD��fL~��vQl���Ql���v{��bS�����t�di���)M%�C��N2:MqP��Hŏ�b��ngm          X  x�]�Mr�0���9Aǒl~��t�t�NRHZ3��W0�F�ֳ,.���v1q����"%q��%��%�
��������ʖ��]���(��@�9�׿��|����¤�]���<h1s�v�8����6)��j��9G����8�6�>VG��j��Y��>R��b���a��%B]�Q�&V�)M�D-^+��ÈUZ�֐�� �G���z�X�@l�^��R{΄�i�;�]
E��E�t� �ىۦ"�ԼQ� ,���� Z��i'��ٖ�'�Nz��78�j�
�*�'-�|����+8�1͇�zj:��|�o�d��ertˤi�NL����V�?����     