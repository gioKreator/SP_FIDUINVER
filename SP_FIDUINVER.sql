CREATE OR REPLACE PROCEDURE DBSBFI.SP_FIDUINVER(
       IN PI_TPROC SMALLINT,
       IN PS_DATOS VARCHAR(3000),
       IN PF_CONTABLE DATE,
       IN PI_USUARIO INTEGER,
       OUT PCH_SQLSTATE_OUT CHARACTER(5),
       OUT PI_SQLCODE_OUT INTEGER,
       OUT PS_MSGERR_OUT VARCHAR(3000)
   )
SPECIFIC SP_FIDUINVER
MODIFIES SQL DATA
NOT
DETERMINISTIC NULL CALL
LANGUAGE SQL /*..........................................................................................
STORED PROCEDURE      : SP_FIDUINVER
OBJETIVO              : PROCESA MOVIMIENTOS INVERSIONES BURSATILES
CREADOR               : ADRIAN FLORES RODRIGUEZ
FECHA CREACION        : 16-OCTUBRE-2017
FECHA MODIFICACION    : 25-01-2017  AFR SE INICIALIZA LA VARIABLE DE FOLIO DE REPORTO
FECHA MODIFICACION	  : 03-05-2018  CGI SE A¶ADE LOGICA PARA TRATAMIENTO DE OPERACIONES FUTURAS
FECHA MODIFICACION	  : 06-07-2018  CGI SE A¶ADE LOGICA PARA TRATAMIENTO DE OPERACIONES DE RECLASIFICACION
OBJETIVO MODIFICACION : 
...........................................................................................*/
   P1:BEGIN --DECLARACIçN DE VARIABLES DE PROCESO
 DECLARE SQLSTATE CHAR( 5 ) DEFAULT '00000';--


--
 --
 DECLARE SQLCODE INT DEFAULT 0;--


--
 --
 DECLARE VI_CTO INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_SCTO INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_CTOINTER DECIMAL(11) DEFAULT 0;--


--
 --
 DECLARE VI_INTERMED SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_MERCADO SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_INSTRUME SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_SECEMIS SMALLINT DEFAULT 0;--


--
 --
 DECLARE VS_PIZARRA VARCHAR(10) DEFAULT ' ';--


--
 --
 DECLARE VS_SERIE VARCHAR(7) DEFAULT ' ';--


--
 --
 DECLARE VI_TITULOS DECIMAL(14) DEFAULT 0;--


--
 --
 DECLARE VI_PRECIO DECIMAL(
   14,
   8
) DEFAULT 0;--


--
 --
 DECLARE VS_OPERNSF VARCHAR(3) DEFAULT ' ';--


--
 --
 DECLARE VI_IMPORTEC DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_COSTO DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_UTILPERD DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_UTILIDAD DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_PERDIDA DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_FOLIO_CONT INTEGER DEFAULT 0;--


--
 --
 DECLARE VS_ADMONPROP VARCHAR(25) DEFAULT ' ';--


--
 --
 DECLARE VI_CLASIF INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_TIPONEG SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_ABI_CERR SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_NIVEL1 SMALLINT DEFAULT 0;--


--
 --
 DECLARE VF_LIQUID DATE;--


--
 --
 DECLARE VF_OPERBUR DATE;--


--
 --
 DECLARE VS_CADENA VARCHAR(2000) DEFAULT ' ';--


--
 --
 DECLARE VS_DATOSMOV VARCHAR(2000) DEFAULT ' ';--


--
 --
 DECLARE VS_DETMOV VARCHAR(500) DEFAULT ' ';--


--
 --
 DECLARE VS_FORMANEG VARCHAR(30) DEFAULT ' ';--


--
 --
 DECLARE VS_PAPEL VARCHAR(10) DEFAULT ' ';--


--
 --
 DECLARE VI_PREMIO DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_PCPACTAD DECIMAL(
   16,
   8
) DEFAULT 0;--


--
 --
 DECLARE VI_PLAZO SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_IMP_COMI DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_IMIVACOM DECIMAL(
   16,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_PUNTUALIDAD DECIMAL(
   16,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_FOLIO INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_SEC INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_CUSTODIO SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_MONEDA SMALLINT DEFAULT 1;--


--
 --
 DECLARE VI_GARANTIA SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_IMPUESTO DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_REG INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_NOREG INTEGER DEFAULT 0;--


--
 --
 DECLARE VI_TOTREG INTEGER DEFAULT 0;--


--
 --
 DECLARE VS_TIPODERECH VARCHAR(100) DEFAULT ' ';--


--
 --
 DECLARE VS_ENCAB VARCHAR(250) DEFAULT ' ';--


--
 --
 DECLARE VS_VALINS VARCHAR(300) DEFAULT ' ';--


--
 --
 DECLARE VS_VALUPD VARCHAR(500) DEFAULT ' ';--


--
 --
 DECLARE VS_VALWHERE VARCHAR(500) DEFAULT ' ';--


--
 --
 DECLARE VI_HAY_POSMSA SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_HAY_POS SMALLINT DEFAULT 0;--


--
 --
 DECLARE VS_ERROR VARCHAR(100) DEFAULT ' ';--


--
 --
 DECLARE VI_FOLIO_REP INTEGER DEFAULT 0;--


--
 --
 DECLARE VF_VENCIMIENTO DATE;--


--
 --
 DECLARE VB_HAYRETRO BOOLEAN DEFAULT FALSE;--


--
 --
 DECLARE VI_CVEOPERA SMALLINT DEFAULT 0;--


--
 --
 DECLARE VS_CONTROL VARCHAR(9) DEFAULT 'CONTINUAR';--


--
 --
 DECLARE VI_INTERES DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_BAJOPAR SMALLINT DEFAULT 0;--


--
 --
 DECLARE VI_MONTO DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_COSHIST DECIMAL(
   14,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_FOLCOMPRA INTEGER DEFAULT 0;--


--
 --
 DECLARE VS_OPER VARCHAR(50) DEFAULT ' ';--


--
 --
 DECLARE VF_ALTAREP DATE;--


--
 --
 DECLARE VS_ST_REPO VARCHAR(20) DEFAULT ' ';--


--
 --
 DECLARE VS_TRANSAC VARCHAR(15) DEFAULT ' ';--


--
 --
 DECLARE VF_UPOACTUAL DATE;--


--
 --
 DECLARE VI_ITERACCION SMALLINT DEFAULT 0;--


--
 --
 DECLARE PF_SISTEMA DATE;--


--
 --
 DECLARE VS_NUMOPERACION VARCHAR(14);--


--
 --
 DECLARE VI_CPRA_COSTO DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_CPRA_IMPORTE DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_CPRA_IVA DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_CPRA_COMISION DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_VTA_COSTO DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_VTA_COSTO_UTIL DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_VTA_COMISION DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_VTA_ISR DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_VTA_IVA DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 --
 DECLARE VI_VTA_IMPORTE DECIMAL(
   18,
   2
) DEFAULT 0;--


--
 DECLARE VI_TRAN_ID_TRAN_CD DECIMAL(
   10,
   0
) DEFAULT 0;--


--
 DECLARE VI_TRAN_ID_TRAN_VD DECIMAL(
   10,
   0
) DEFAULT 0;--


--
 ------------------------------------------------------------------------
 -- DECLARACIçN DE MANEJADORES DE ERROR
 ------------------------------------------------------------------------ 
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION GET DIAGNOSTICS EXCEPTION 1 PS_MSGERR_OUT = MESSAGE_TEXT;--


--
 --
 SELECT
   SQLSTATE,
   SQLCODE INTO        PCH_SQLSTATE_OUT,
       PI_SQLCODE_OUT
   FROM        SYSIBM.SYSDUMMY1;--


--
 /*INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       (
           SELECT
               COALESCE(
                   MAX( CVE_NUM_SEC_CLAVE ),
                   0
               )+ 1
           FROM                CLAVES
           WHERE                CVE_NUM_CLAVE =- 5
       ),
       'SE ENCONTRO ERROR EN PROCESO - ' || PCH_SQLSTATE_OUT || ' - ' || PI_SQLCODE_OUT,
       0,
       0,
       CHAR( CURRENT_TIMESTAMP ),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
   */


--
 --
SET PS_MSGERR_OUT = 'SP_FIDUINVER ' || PS_MSGERR_OUT;--


--
 --
 RESIGNAL;--


--
 --
END;--


--
 --
 DECLARE GLOBAL TEMPORARY TABLE
   PROC_NOCT(
       FH_ACTUAL DATE,
       NO_REG INTEGER,
       ST_REG INTEGER,
       NU_FOLIO INTEGER,
       FH_OPERBUR DATE,
       FH_LIQUID DATE,
       TX_PAPEL VARCHAR(10),
       NU_MONEDA SMALLINT,
       NU_CTOINTER DECIMAL(11),
       TX_PIZARRA VARCHAR(8),
       TX_SERIE VARCHAR(7),
       DE_TITULOS DECIMAL(14),
       DE_PRECIO DECIMAL(14, 8),
       DE_MONTO DECIMAL(14, 2),
       DE_IMP_COMI DECIMAL(14, 2),
       DE_INTERES DECIMAL(14, 2),
       DE_IMPUESTO DECIMAL(14, 2),
       NU_CVEOPERA INTEGER,
       NU_PLAZO SMALLINT,
       DE_PCPACTAD DECIMAL(16, 8),
       FH_VENCIM DATE,
       TX_HULTMOD TIME,
       DE_IMIVACOM DECIMAL(16, 2),
       NU_TPMERCA SMALLINT,
       NU_INSTRUMENT SMALLINT,
       NU_SECEMIS INTEGER,
       NU_CTO INTEGER,
       NU_SCTO INTEGER,
       TX_ESTADOCTO VARCHAR(15),
       TX_TP_ADMON VARCHAR(25),
       NU_TIENESUB SMALLINT,
       NU_NIVEL1 SMALLINT,
       NU_ABI_CERR SMALLINT,
       NU_TIPONEG SMALLINT,
       NU_CLASIF INTEGER,
       TX_OPERNSF VARCHAR(3),
       NU_INTERMED SMALLINT DEFAULT 0,
       NU_CUSTODIO SMALLINT DEFAULT 0,
       DE_IMPORTEC DECIMAL(14, 2),
       DE_PRECIOC DECIMAL(14, 8),
       TX_TIPODERECH VARCHAR(100),
       TX_FORMANEG VARCHAR(30),
       NU_PREMIO DECIMAL(14,2),
       TX_ERROR VARCHAR(100),
       NU_SEC INTEGER
   ) WITH REPLACE ON
   COMMIT PRESERVE ROWS NOT LOGGED;--


--
 --
 COMMIT WORK;--


--
 --
 DECLARE GLOBAL TEMPORARY TABLE
   UTILPERD(
       SEC SMALLINT,
       CPE_NUM_CONTRATO INTEGER NOT NULL,
       CPE_SUB_CONTRATO SMALLINT NOT NULL,
       CPE_ENTIDAD_FIN SMALLINT NOT NULL,
       CPE_CONTRATO_INTER DECIMAL(11, 0) NOT NULL,
       CPE_CVE_TIPO_MERCA SMALLINT NOT NULL,
       CPE_NUM_INSTRUME SMALLINT NOT NULL,
       CPE_NUM_SEC_EMIS SMALLINT NOT NULL,
       CPE_SEC_DIA_COMPRA INTEGER NOT NULL,
       CPE_NOM_PIZARRA VARCHAR(10) NOT NULL,
       CPE_NUM_SERIE_EMIS VARCHAR(7) NOT NULL,
       CPE_NUM_MONEDA SMALLINT NOT NULL,
       CPE_PRECIO_EMISION DECIMAL(19, 11) NOT NULL,
       CPE_TIT_DISP_COMP DECIMAL(16, 0) NOT NULL,
       CPE_FOLIO_CANCELA VARCHAR(30),
       TITULOS DECIMAL(14),
       PRECIO DECIMAL(14, 8)
   ) WITH REPLACE ON
   COMMIT PRESERVE ROWS NOT LOGGED;--


--
 --
 COMMIT WORK;--


--
 --
 DECLARE GLOBAL TEMPORARY TABLE
   HAYPOS(
       SEC SMALLINT,
       HAYPOSI SMALLINT
   ) WITH REPLACE ON
   COMMIT PRESERVE ROWS NOT LOGGED;--


--
 --
 COMMIT WORK;--


--
 --
SET PCH_SQLSTATE_OUT = '00000';--


--
 --
SET PI_SQLCODE_OUT = 0;--


--
 --
SET PS_MSGERR_OUT = '';--


--
 --
 SELECT
   CURRENT_DATE INTO        PF_SISTEMA
   FROM        SYSIBM.SYSDUMMY1;--


--
 --
 IF PF_CONTABLE > PF_SISTEMA THEN
SET PS_MSGERR_OUT = 'LA FECHA VALOR NO PUEDE SER MAYOR AL DIA ACTUAL';--


--
 --
 GOTO SALIDA;--


--
 --
END IF;--


--
 --
 /*ESTO QUITARLO
  SET PF_SISTEMA = PF_CONTABLE;--
--
--
 ESTA LINEA DE ARRIBA QUITARLA*/
IF PI_TPROC = 1 THEN -- BATCH = 1
 DELETE
FROM    CLAVES
WHERE    CVE_NUM_CLAVE =- 5;--


--
 --
 INSERT
   INTO SESSION.PROC_NOCT SELECT
           ope.upo_factualiza,
           ope.upo_RECNO,
           ope.upo_status_rec,
           substr(ope.upo_linea, 1, 6),
           substr(ope.upo_linea, 7, 10),
           substr(ope.upo_linea, 17, 10),
           substr(ope.upo_linea, 28, 10),
           substr(ope.upo_linea, 41, 1),
           ope.cpr_contrato_inter,
           LTRIM( RTRIM( substr( ope.upo_linea, 50, 8 ))),
           LTRIM( RTRIM( substr( ope.upo_linea, 58, 6 ))),
           substr(ope.upo_linea, 67, 1)|| substr(ope.upo_linea, 68, 11),
           CASE substr(ope.upo_linea, 79, 1)
              WHEN ' ' THEN ' '
              ELSE '-'
            END || substr(ope.upo_linea, 80, 7)|| '.' || substr(ope.upo_linea, 87, 7),
           CASE substr(ope.upo_linea, 94, 1)
               WHEN ' ' THEN ' '
               ELSE '-'
            END || substr(ope.upo_linea, 95, 13)|| '.' || substr(ope.upo_linea, 108, 2),
           CASE substr(ope.upo_linea, 110, 1)
               WHEN ' ' THEN ' '
               ELSE '-'
            END || substr(ope.upo_linea, 111, 13)|| '.' || substr(ope.upo_linea, 124, 2),
           CASE substr(ope.upo_linea, 126, 1)
               WHEN ' ' THEN ' '
               ELSE '-'
            END || substr(ope.upo_linea, 127, 13)|| '.' || substr(ope.upo_linea, 140, 2),
           CASE substr(ope.upo_linea, 142, 1)
               WHEN ' ' THEN ' '
               ELSE '-'
            END || substr(ope.upo_linea, 143, 13)|| '.' || substr(ope.upo_linea, 156, 2),
           CAST(substr(ope.upo_linea, 161, 4) AS INTEGER),
           substr(ope.upo_linea, 166, 4),
           CASE substr(ope.upo_linea, 182, 1)
               WHEN ' ' THEN ' '
               ELSE '-'
           END || substr(ope.upo_linea, 183, 3)|| '.' || substr(ope.upo_linea, 186, 8),
           substr(ope.upo_linea, 195, 10),
           substr(ope.upo_linea, 214, 8
           ),
           CASE substr(ope.upo_linea, 236, 1)
               WHEN ' ' THEN ' '
               ELSE '-'
           END || substr(ope.upo_linea, 237, 13)|| '.' || substr(ope.upo_linea, 250, 2),
           ins_cve_tipo_merca,
           ins_num_instrume,
           emi_num_sec_emis,
           cto.cto_num_contrato,
           COALESCE(ope.cpr_sub_contrato, 0),
           cto.cto_cve_st_contrat,
           COALESCE(cto.cto_tipo_admon, 'XX'),
           COALESCE(cto.cto_cve_subcto, 0),
           cto.cto_num_nivel1,
           cto.cto_cve_req_sors,
           t.cve_num_sec_clave,
           c.cve_num_sec_clave,
           obb.cao_cpa_vta_nsf,
           0,
           0,
           0,
           0,
           '',
           '',
           0,
           '',
           0
       FROM            fid_inv_upd_operacion ope,                 *********************** Sutituir por OPERACIONESCUSTODIA ****************************
           contrato cto,
           claves t,
           claves c,
           fid_inv_cat_operacion_bpigo obb
       WHERE ope.upo_status_rec =- 1
           AND( CAST(
                   substr(ope.upo_linea, 17, 10) AS DATE 
                ) <= PF_CONTABLE
               OR(
                   CAST(
                       substr(ope.upo_linea, 17, 10) AS DATE
                   ) > PF_CONTABLE
                   AND CAST(
                          substr(ope.upo_linea, 7, 10) AS DATE
                        ) = PF_CONTABLE
                   AND obb.cao_cpa_vta_nsf IN(
                       'CD',
                       'VD',
                       'RE',
                       'DE'
                   )
               )
           )
           AND cto.cto_num_contrato = ope.cpr_num_contrato
           AND cto.cto_es_eje = 0
           AND(cto.cto_cve_st_contrat = 'ACTIVO' OR cto.cto_cve_st_contrat = 'ANTEPROYECTO')
           AND obb.cao_cdopera = CAST(substr(ope.upo_linea, 161, 4) AS INTEGER)
           AND t.cve_num_clave = 36
           AND t.cve_desc_clave = cto.cto_cve_tipo_neg
           AND c.cve_num_clave = 37
           AND c.cve_desc_clave = cto.cto_cve_clas_prod WITH UR;--


--
 --
SELECT
  COUNT(*) INTO        VI_TOTREG
FROM        SESSION.PROC_NOCT;--


--
 --
 IF VI_TOTREG > 0 THEN 
 /* INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       0,
       'EMPIEZA PROCESO',
       0,
       0,
       CHAR( CURRENT_TIMESTAMP ),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
*/

--
 --
 --DEL UNIVERSO DE OPERACIONES INCLUIDO EN LA TABLA PROC_NOCT, SE TOMAN LAS OPERACIONES FUTURAS Y SE INSERTAN EN LA TABLA TFI259_OPE_FUT_IND
 --
 INSERT
   INTO GDB2PR.TFI259_OPE_FUT_IND SELECT
           FH_ACTUAL,
           NO_REG,
           NU_CTO,
           NU_SCTO,
           NU_CTOINTER,
           FH_OPERBUR,
           FH_LIQUID,
           SUBSTR(NU_CTOINTER, 1, 3),
           TX_OPERNSF,
           TX_PIZARRA,
           TX_SERIE,
           0,
           DE_TITULOS,
           DE_PRECIO,
           DE_MONTO,
           NULL,
           NULL,
           NULL,
           NULL,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) 
                  IN (903, 919)
                  OR TX_OPERNSF IN('DE', 'RE') 
               THEN 0
               ELSE 1
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           CASE
               WHEN SUBSTR(NU_CTOINTER, 1, 3) IN (903) THEN NULL
               ELSE 0
           END,
           NU_TIPONEG,
           NULL
       FROM            SESSION.PROC_NOCT
       WHERE            FH_OPERBUR < FH_LIQUID
           AND TX_OPERNSF IN(
               'CD',
               'VD',
               'RE',
               'DE'
           );--


--
 --
 --OBTIENE INTERMEDIARIO Y CUSTODIO O VERIFICA STATUS DE CONTINTE
 UPDATE
   SESSION.PROC_NOCT A
SET    A.NU_INTERMED =(
       SELECT
           CPR_ENTIDAD_FIN
       FROM            CONTINTE,
           INTERMED
       WHERE            A.NU_CTOINTER = CPR_CONTRATO_INTER
           AND CPR_ENTIDAD_FIN = INT_ENTIDAD_FIN
           AND CPR_CVE_ST_CONTINT = 'ACTIVO' FETCH FIRST 1 ROWS ONLY
   ),
   A.NU_CUSTODIO =(
       SELECT
           INT_SUCURSAL_AL
       FROM            CONTINTE,
           INTERMED
       WHERE            A.NU_CTOINTER = CPR_CONTRATO_INTER
           AND CPR_ENTIDAD_FIN = INT_ENTIDAD_FIN
           AND CPR_CVE_ST_CONTINT = 'ACTIVO' FETCH FIRST 1 ROWS ONLY
   ) WITH UR;--


--
 --
 --ACTUALIZA INTERMEDIARIO (PROVEEDOR) EN LA TABLA DE OPERACIONES FUTURAS
 --
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND A
SET    A.CD_PROVEEDOR =(
       SELECT
           CPR_ENTIDAD_FIN
       FROM            CONTINTE,
           INTERMED
       WHERE            A.CD_CONTRATO_INVER = CPR_CONTRATO_INTER
           AND CPR_ENTIDAD_FIN = INT_ENTIDAD_FIN
           AND CPR_CVE_ST_CONTINT = 'ACTIVO'
           AND A.FH_CARGA = PF_CONTABLE FETCH FIRST 1 ROWS ONLY
   ) WITH UR;--


--
 --
 --VALIDA QUE EXISTA TIPO DE OPERACION
 UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR = '860 OPERACIçN SIN CORRESPONDENCIA MUV'
WHERE    TX_OPERNSF = '';--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR = '090 EL INTERMEDIARIO O CUSTODIO NO REGISTRADO/O ESTADO DE CTO INVERSION INACTIVO'
WHERE    NU_INTERMED = 0
   OR NU_CUSTODIO = 0
   OR NU_INTERMED IS NULL;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_OPERNSF = 'AMC',
   DE_IMPORTEC = 0
WHERE    TX_OPERNSF = 'AMT'
   AND DE_TITULOS = 0;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR = '087 LOS TITULOS DEBEN SER MAYOR A CERO PARA OPERACION ' || TX_OPERNSF
WHERE    TX_OPERNSF IN(
       'CD',
       'VD',
       'DE',
       'RE',
       'AMT'
   )
   AND DE_TITULOS = 0;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    DE_IMPORTEC = DE_TITULOS * DE_PRECIO
WHERE    TX_OPERNSF IN(
       'DE',
       'RE'
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    DE_IMPORTEC = DE_MONTO - DE_IMP_COMI - DE_IMIVACOM + DE_INTERES
WHERE    TX_OPERNSF = 'CD';--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    DE_IMPORTEC = DE_MONTO + DE_IMP_COMI + DE_IMIVACOM + DE_IMPUESTO - DE_INTERES
WHERE    TX_OPERNSF IN(
       'VD',
       'AMT'
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    DE_IMPORTEC = DE_MONTO,
   NU_PREMIO = DE_MONTO * NU_PLAZO * DE_PCPACTAD / 36000
WHERE    TX_OPERNSF IN('CR');--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    DE_IMPORTEC = DE_MONTO
WHERE    TX_OPERNSF IN('PI');--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_FORMANEG = 'Pago de Intereses'
WHERE    TX_OPERNSF IN('PI')
   AND NU_CVEOPERA IN(
       50,
       360
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_FORMANEG = 'DIRECTO',
   NU_PLAZO = 0,
   DE_PCPACTAD = 0
WHERE    TX_OPERNSF IN(
       'CD',
       'VD',
       'DE',
       'RE',
       'AMT',
       'AMC'
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_FORMANEG = 'PLAZO'
WHERE    TX_OPERNSF IN(
       'CR',
       'VR'
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    DE_PRECIO = ROUND( DE_IMPORTEC / DE_TITULOS,+ 8 )
WHERE    TX_OPERNSF IN(
       'CD',
       'VD',
       'DE',
       'RE',
       'AMT'
   )
   AND DE_IMPORTEC > 0
   AND DE_TITULOS > 0;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_TIPODERECH = CASE
       WHEN DE_TITULOS <> 0 THEN ' -.- ' || TX_PIZARRA || ' TITULOS: ' || DE_TITULOS || ' SERIE:' || TX_SERIE
       ELSE ' -.- ' || TX_PIZARRA || ' TITULOS: ' || '0.00' || ' SERIE:' || TX_SERIE
   END
WHERE    TX_OPERNSF IN(
       'CD',
       'VD',
       'RE',
       'DE',
       'AMT',
       'AMC'
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_TIPODERECH = ' REPORTO AL ' || DE_PCPACTAD || '% A ' || NU_PLAZO || ' DIAS '
WHERE    TX_OPERNSF IN('CR');--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_TIPODERECH = ' -.- ' || TX_PIZARRA || ' TITULOS: ' || DE_TITULOS || ' SERIE:' || TX_SERIE
WHERE    TX_OPERNSF IN('VR')
   OR(
       TX_OPERNSF IN('PI')
       AND NU_CVEOPERA IN(
           50,
           360
       )
   );--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_TIPODERECH = ' -.- ' || 'Dividendo en efectivo: ' || TX_PIZARRA || ' TITULOS: 0 SERIE: ' || TX_SERIE,
   TX_FORMANEG = 'Dividendos en Efectivo'
WHERE    TX_OPERNSF = 'PI'
   AND NU_CVEOPERA = 16;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_TIPODERECH = ' -.- ' || 'Dividendo Cufin: ' || TX_PIZARRA || ' TITULOS: 0 SERIE: ' || TX_SERIE,
   TX_FORMANEG = 'Dividendos Cufin'
WHERE    TX_OPERNSF = 'PI'
   AND NU_CVEOPERA = 59;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_TIPODERECH = ' -.- ' || 'Dividendo Cufinre: ' || TX_PIZARRA || ' TITULOS: 0 SERIE: ' || TX_SERIE,
   TX_FORMANEG = 'Dividendos Cufinre'
WHERE    TX_OPERNSF = 'PI'
   AND NU_CVEOPERA = 60;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    NU_SEC = ROW_NUMBER() OVER(
   ORDER BY
       FH_OPERBUR,
       NU_FOLIO,
       TX_HULTMOD
   );--


--
 --
 -- NO HAY RETROACTIVIDAD EN EL BATCH NOCTURNO
 --IF PF_CONTABLE < PF_SISTEMA - (DAY(PF_SISTEMA)-1) DAY THEN
SET VB_HAYRETRO = FALSE;--


--
 --
 --END IF;--
--
 --
SET VI_TOTREG = 0;--


--
 --
SET VI_ITERACCION = 1;--


--
 --
 WHILE VI_ITERACCION <= 2 DO IF VI_ITERACCION = 1 THEN SELECT
   MAX( NU_SEC ) INTO        VI_TOTREG
   FROM        SESSION.PROC_NOCT;--


--
 --
ELSE
SET VI_TOTREG = 0;--


--
 --
 SELECT
   COALESCE(
       MAX( NU_SEC ),
       0
   ) INTO        VI_TOTREG
   FROM        SESSION.PROC_NOCT
   WHERE        TX_ERROR = 'SEGUNDA VUELTA';--


--
 --
END IF;--


--
 --
SET VI_REG = 1;--


--
 --
 WHILE VI_REG <= VI_TOTREG DO
SET VI_CTO = 0,
VI_SCTO = 0,
VI_CTOINTER = 0,
VI_INTERMED = 0,
VI_MERCADO = 0,
VI_INSTRUME = 0,
VI_SECEMIS = 0,
VS_PIZARRA = ' ',
VS_SERIE = ' ',
VI_TITULOS = 0,
VI_PRECIO = 0;--


--
 --
SET VS_OPERNSF = ' ',
VI_IMPORTEC = 0,
VI_COSTO = 0,
VI_UTILPERD = 0,
VI_UTILIDAD = 0,
VI_PERDIDA = 0,
VS_ADMONPROP = ' ',
VI_CLASIF = 0,
VI_TIPONEG = 0,
VI_ABI_CERR = 0;--


--
 --
SET VS_FORMANEG = ' ',
VS_PAPEL = ' ',
VI_PREMIO = 0,
VI_PCPACTAD = 0,
VI_PLAZO = 0,
VI_IMP_COMI = 0,
VI_IMIVACOM = 0,
VI_PUNTUALIDAD = 0,
VI_FOLIO = 0,
VI_CUSTODIO = 0,
VI_GARANTIA = 0;--


--
 --
SET VI_FOLIO_REP = 0;--


--
 IF VI_ITERACCION = 2 THEN SELECT
   MIN( NU_SEC ) INTO        VI_REG
   FROM        SESSION.PROC_NOCT
   WHERE        TX_ERROR = 'SEGUNDA VUELTA';--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR =(
       SELECT
           CASE
               WHEN(
                   COALESCE(
                       B.POS_POSIC_ACTUAL,
                       0
                   )- A.DE_TITULOS
               )>= 0 THEN ''
               ELSE '960 NO HAY TITULOS SUFICIENTES PARA VENDER'
           END
       FROM            (
               SELECT
                   *
               FROM                    SESSION.PROC_NOCT
               WHERE                    NU_SEC = VI_REG
           ) A
       LEFT OUTER JOIN POSICION B ON
           (
               B.POS_NUM_CONTRATO = A.NU_CTO
               AND B.POS_SUB_CONTRATO = A.NU_SCTO
               AND B.POS_NUM_ENTID_FIN = A.NU_INTERMED
               AND B.POS_CONTRATO_INTER = A.NU_CTOINTER
               AND B.POS_CVE_TIPO_MERCA = A.NU_TPMERCA
               AND B.POS_NUM_INSTRUME = A.NU_INSTRUMENT
               AND B.POS_NUM_SEC_EMIS = A.NU_SECEMIS
               AND B.POS_NOM_PIZARRA = A.TX_PIZARRA
               AND B.POS_NUM_SER_EMIS = A.TX_SERIE
               AND B.POS_NUM_CUPON_VIG = 0
               AND A.TX_OPERNSF IN(
                   'VD',
                   'RE',
                   'AMT'
               )
               AND A.TX_ERROR = 'SEGUNDA VUELTA'
           )
   )
WHERE    NU_SEC = VI_REG
   AND TX_OPERNSF IN(
       'VD',
       'RE',
       'AMT'
   );--


--
 --
ELSE UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR =(
       SELECT
           CASE
               WHEN(
                   COALESCE(
                       B.POS_POSIC_ACTUAL,
                       0
                   )- A.DE_TITULOS
               )>= 0 THEN ''
               ELSE 'SEGUNDA VUELTA'
           END
       FROM            (
               SELECT
                   *
               FROM                    SESSION.PROC_NOCT
               WHERE                    NU_SEC = VI_REG
           ) A
       LEFT OUTER JOIN POSICION B ON
           (
               B.POS_NUM_CONTRATO = A.NU_CTO
               AND B.POS_SUB_CONTRATO = A.NU_SCTO
               AND B.POS_NUM_ENTID_FIN = A.NU_INTERMED
               AND B.POS_CONTRATO_INTER = A.NU_CTOINTER
               AND B.POS_CVE_TIPO_MERCA = A.NU_TPMERCA
               AND B.POS_NUM_INSTRUME = A.NU_INSTRUMENT
               AND B.POS_NUM_SEC_EMIS = A.NU_SECEMIS
               AND B.POS_NOM_PIZARRA = A.TX_PIZARRA
               AND B.POS_NUM_SER_EMIS = A.TX_SERIE
               AND B.POS_NUM_CUPON_VIG = 0
               AND A.TX_OPERNSF IN(
                   'VD',
                   'RE',
                   'AMT'
               )
               AND(
                   A.TX_ERROR = ''
                   OR A.TX_ERROR IS NULL
               )
           )
   )
WHERE    NU_SEC = VI_REG
   AND TX_OPERNSF IN(
       'VD',
       'RE',
       'AMT'
   );--


--
 --
END IF;--


--
 --
 SELECT
   NO_REG,
   NU_FOLIO,
   TX_OPERNSF,
   NU_CTO,
   NU_SCTO,
   NU_CTOINTER,
   NU_INTERMED,
   NU_TPMERCA,
   NU_INSTRUMENT,
   NU_SECEMIS,
   TX_PIZARRA,
   TX_SERIE,
   DE_TITULOS,
   DE_PRECIO,
   DE_IMPORTEC,
   TX_TP_ADMON,
   NU_CLASIF,
   NU_TIPONEG,
   NU_ABI_CERR,
   NU_NIVEL1,
   FH_OPERBUR,
   FH_LIQUID,
   DE_IMPUESTO,
   TX_TIPODERECH,
   NU_CUSTODIO,
   TX_FORMANEG,
   TX_PAPEL,
   NU_PREMIO,
   DE_PCPACTAD,
   NU_PLAZO,
   DE_IMP_COMI,
   DE_IMIVACOM,
   FH_VENCIM,
   NU_CVEOPERA,
   DE_INTERES,
   DE_MONTO,
   FH_ACTUAL,
   TX_ERROR INTO        VI_NOREG,
       VI_FOLIO,
       VS_OPERNSF,
       VI_CTO,
       VI_SCTO,
       VI_CTOINTER,
       VI_INTERMED,
       VI_MERCADO,
       VI_INSTRUME,
       VI_SECEMIS,
       VS_PIZARRA,
       VS_SERIE,
       VI_TITULOS,
       VI_PRECIO,
       VI_IMPORTEC,
       VS_ADMONPROP,
       VI_CLASIF,
       VI_TIPONEG,
       VI_ABI_CERR,
       VI_NIVEL1,
       VF_OPERBUR,
       VF_LIQUID,
       VI_IMPUESTO,
       VS_TIPODERECH,
       VI_CUSTODIO,
       VS_FORMANEG,
       VS_PAPEL,
       VI_PREMIO,
       VI_PCPACTAD,
       VI_PLAZO,
       VI_IMP_COMI,
       VI_IMIVACOM,
       VF_VENCIMIENTO,
       VI_CVEOPERA,
       VI_INTERES,
       VI_MONTO,
       VF_UPOACTUAL,
       VS_ERROR
   FROM        SESSION.PROC_NOCT
   WHERE        NU_SEC = VI_REG;--


--
 --
 IF VI_ITERACCION = 2
AND VS_ERROR = 'SEGUNDA VUELTA' THEN
SET VS_ERROR = '';--


--
END IF;--


--
 /* INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       (
           SELECT
               COALESCE(
                   MAX( CVE_NUM_SEC_CLAVE ),
                   0
               )+ 1
           FROM                CLAVES
           WHERE                CVE_NUM_CLAVE =- 5
       ),
       'TIPO OPERACION' || ' ' || VS_OPERNSF || 'ITER ' || VI_ITERACCION,
       VI_REG,
       VI_TOTREG,
       CHAR( CURRENT_TIMESTAMP ),
       VI_NOREG,
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
*/

--
 --
 IF VS_ERROR = ''
OR VS_ERROR IS NULL THEN IF VS_OPERNSF = 'VD'
OR VS_OPERNSF = 'RE'
OR VS_OPERNSF = 'AMT'
OR VS_OPERNSF = 'AM' THEN DELETE
FROM    SESSION.UTILPERD;--


--
 --
 INSERT
   INTO        SESSION.UTILPERD SELECT
           ROW_NUMBER() OVER(
               PARTITION BY CPE_NUM_CONTRATO,
               CPE_SUB_CONTRATO
           ORDER BY
               CPE_SEC_DIA_COMPRA
           ),
           CPE_NUM_CONTRATO,
           CPE_SUB_CONTRATO,
           CPE_ENTIDAD_FIN,
           CPE_CONTRATO_INTER,
           CPE_CVE_TIPO_MERCA,
           CPE_NUM_INSTRUME,
           CPE_NUM_SEC_EMIS,
           CPE_SEC_DIA_COMPRA,
           CPE_NOM_PIZARRA,
           CPE_NUM_SERIE_EMIS,
           CPE_NUM_MONEDA,
           CPE_PRECIO_EMISION,
           CPE_TIT_DISP_COMP,
           CPE_FOLIO_CANCELA,
           VI_TITULOS,
           VI_PRECIO
       FROM            COMPEMIS
       WHERE            CPE_NUM_CONTRATO = VI_CTO
           AND CPE_SUB_CONTRATO = VI_SCTO
           AND CPE_CONTRATO_INTER = VI_CTOINTER
           AND CPE_ENTIDAD_FIN = VI_INTERMED
           AND CPE_CVE_TIPO_MERCA = VI_MERCADO
           AND CPE_NUM_INSTRUME = VI_INSTRUME
           AND CPE_NUM_SEC_EMIS = VI_SECEMIS
           AND CPE_NOM_PIZARRA = VS_PIZARRA
           AND CPE_NUM_SERIE_EMIS = VS_SERIE
           AND CPE_CVE_ST_COMPEMI = 'ACTIVO'
           AND CPE_TIT_DISP_COMP > 0 WITH UR;--


--
 --
SET VI_HAY_POS = 0;--


--
 --
 SELECT
   COUNT(*) INTO        VI_HAY_POS
   FROM        SESSION.UTILPERD;--


--
 --
 IF VI_HAY_POS > 0 THEN UPDATE
   SESSION.UTILPERD A
SET    A.TITULOS = 0
WHERE    A.SEC > 1;--


--
 --
 UPDATE
   SESSION.UTILPERD A
SET    A.TITULOS =(
       SELECT
           SUM( B.TITULOS )- SUM( B.CPE_TIT_DISP_COMP )
       FROM            SESSION.UTILPERD b
       WHERE            B.SEC < A.SEC
   )
WHERE    A.SEC > 1;--


--
 --
 SELECT
   SUM( CASE WHEN( TITULOS >= CPE_TIT_DISP_COMP ) THEN( CPE_TIT_DISP_COMP * CPE_PRECIO_EMISION ) ELSE( TITULOS * CPE_PRECIO_EMISION ) END ) INTO        VI_COSTO
   FROM        SESSION.UTILPERD
   WHERE        TITULOS > 1
   GROUP BY
       CPE_NUM_CONTRATO;--


--
 --
 IF VS_OPERNSF = 'RE'
AND PI_USUARIO = 999 THEN
SET VI_IMPORTEC = VI_COSTO;--


--
 --
SET VI_PRECIO = VI_COSTO / VI_TITULOS;--


--
 --
END IF;--


--
 --
SET VI_UTILPERD = ROUND( VI_IMPORTEC,+ 2 )- ROUND( VI_COSTO,+ 2 );--


--
 --
SET VI_HAY_POS = 0;--


--
 --
ELSE
SET VS_ERROR = '104 NO HAY TITULOS DISPONIBLES PARA CALCULO DE PLUS-MINUS';--


--
 --
 GOTO SIGUIENTE;--


--
 --
SET VI_HAY_POS = 0;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'AMC' THEN SELECT
   POS_COSTO_HISTORIC INTO        VI_COSHIST
   FROM        POSICION
   WHERE        POS_NUM_CONTRATO = VI_CTO
       AND POS_SUB_CONTRATO = VI_SCTO
       AND POS_NUM_ENTID_FIN = VI_INTERMED
       AND POS_CONTRATO_INTER = VI_CTOINTER
       AND POS_CVE_TIPO_MERCA = VI_MERCADO
       AND POS_NUM_INSTRUME = VI_INSTRUME
       AND POS_NUM_SEC_EMIS = VI_SECEMIS
       AND POS_NOM_PIZARRA = VS_PIZARRA
       AND POS_NUM_SER_EMIS = VS_SERIE
       AND POS_NUM_CUPON_VIG = 0 WITH UR;--


--
 --
SET VI_UTILPERD = VI_MONTO - VI_COSHIST;--


--
 --
END IF;--


--
 --
SET VS_OPER = 'CD,VD,DE,RE,AM,AMT,VR';--


--
 --
 IF POSSTR(
   VS_OPER,
   VS_OPERNSF
)> 0 THEN IF VI_IMP_COMI <> 0 THEN
SET VI_PUNTUALIDAD = VI_IMIVACOM;--


--
 --
ELSE
SET VI_PUNTUALIDAD = 0;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'CR' THEN SELECT
   FOL_NUM_FOLIO + 1 INTO        VI_FOLIO_REP
   FROM        FOLIOS
   WHERE        FOL_TIPO_FOLIO = 500 WITH UR;--


--
 --
 UPDATE
   FOLIOS
SET    FOL_NUM_FOLIO = VI_FOLIO_REP
WHERE    FOL_TIPO_FOLIO = 500 WITH UR;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'VR' THEN IF VS_PAPEL = '0' THEN SELECT
   CRE_FOLIO_REPORTO,
   CRE_CVE_ST_CONREPO,
   CRE_PREMIO_REPORTO,
   CRE_FEC_ALTA_REG,
   CRE_NUM_MONEDA,
   CRE_IMP_REPORTO INTO        VI_FOLIO_REP,
       VS_ST_REPO,
       VI_PREMIO,
       VF_ALTAREP,
       VI_MONEDA,
       VI_IMPORTEC
   FROM        FDCONREPOR
   WHERE        CRE_NUM_CONTRATO = VI_CTO
       AND CRE_SUB_CONTRATO = VI_SCTO
       AND CRE_ENTIDAD_FIN = VI_INTERMED
       AND CRE_CONTRATO_INTER = VI_CTOINTER
       AND CRE_NUM_PLAZO = VI_PLAZO
       AND CRE_CVE_TIPO_MERCA = VI_MERCADO
       AND CRE_NUM_INSTRUME = VI_INSTRUME
       AND CRE_IMP_REPORTO = VI_IMPORTEC
       AND CRE_FEC_VENCIM = VF_VENCIMIENTO
       AND CRE_NUM_MONEDA = VI_MONEDA WITH UR;--


--
 --
ELSE SELECT
   CRE_FOLIO_REPORTO,
   CRE_CVE_ST_CONREPO,
   CRE_PREMIO_REPORTO,
   CRE_FEC_ALTA_REG,
   CRE_NUM_MONEDA,
   CRE_IMP_REPORTO INTO        VI_FOLIO_REP,
       VS_ST_REPO,
       VI_PREMIO,
       VF_ALTAREP,
       VI_MONEDA,
       VI_IMPORTEC
   FROM        FDCONREPOR
   WHERE        CRE_NUM_CONTRATO = VI_CTO
       AND CRE_SUB_CONTRATO = VI_SCTO
       AND CRE_ENTIDAD_FIN = VI_INTERMED
       AND CRE_CONTRATO_INTER = VI_CTOINTER
       AND CRE_CVE_TIPO_MERCA = VI_MERCADO
       AND CRE_NUM_INSTRUME = VI_INSTRUME
       AND CRE_NUM_MONEDA = VI_MONEDA
       AND CRE_FOLIO_AMORT = CAST(
           VS_PAPEL AS INTEGER
       )
       AND CRE_FEC_VENCIM = VF_VENCIMIENTO WITH UR;--


--
 --
END IF;--


--
 --
 IF VI_FOLIO_REP = 0 THEN IF VI_ITERACCION = 2 THEN
SET VS_ERROR = '100 REGISTRO DE VENCIMIENTO (REPORTO) NO LOCALIZADO';--


--
 --
ELSE
SET VS_ERROR = 'SEGUNDA VUELTA';--


--
 --  
END IF;--


--
 GOTO SIGUIENTE;--


--
 --
END IF;--


--
 --
 IF VS_ST_REPO = 'AMORTIZADO' THEN
SET VS_ERROR = '101 EL VENCIMIENTO YA ESTA AMORTIZADO NO SE PUEDE VOLVER A AMORTIZAR';--


--
 --
 GOTO SIGUIENTE;--


--
 --
ELSE IF VI_IMPUESTO > VI_PREMIO THEN
SET VI_IMPUESTO = VI_PREMIO;--


--
END IF;--


--
END IF;--


--
 --
SET VI_COSTO = VI_IMPORTEC;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'PI' THEN IF VI_CVEOPERA = 50
OR VI_CVEOPERA = 360 THEN SELECT
   POS_POSIC_ACTUAL INTO        VI_TITULOS
   FROM        POSICION
   WHERE        POS_NOM_PIZARRA = VS_PIZARRA
       AND POS_NUM_SER_EMIS = VS_SERIE
       AND POS_CVE_TIPO_MERCA = VI_MERCADO
       AND POS_NUM_INSTRUME = VI_INSTRUME
       AND POS_NUM_SEC_EMIS = VI_SECEMIS
       AND POS_NUM_MONEDA = VI_MONEDA
       AND POS_NUM_CONTRATO = VI_CTO
       AND POS_SUB_CONTRATO = VI_SCTO
       AND POS_NUM_ENTID_FIN = VI_INTERMED
       AND POS_CONTRATO_INTER = VI_CTOINTER WITH UR;--


--
 --
ELSE IF VI_CVEOPERA = 16 THEN
SET VS_TRANSAC = 'Efectivo';--


--
 --
 ELSEIF VI_CVEOPERA = 59 THEN
SET VS_TRANSAC = 'Cufin';--


--
 --
 ELSEIF VI_CVEOPERA = 60 THEN
SET VS_TRANSAC = 'Cufinre';--


--
 --
END IF;--


--
 --
SET VI_PLAZO = 0;--


--
 --
SET VI_FOLIO_REP = 0;--


--
 --
SET VI_PREMIO = 0;--


--
 --
SET VI_PCPACTAD = 0;--


--
 --
SET VF_VENCIMIENTO = CURRENT_DATE;--


--
 --
SET VI_TITULOS = 0;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
SET VS_CADENA = '<<<bProcesoBatch=FALSE>>><<<dAcumValoresLiquidez=' || VS_PAPEL || '>>><<<dAmortizacionEmision=' || DBSBFI.FUN_DEC_TO_CHAR(VI_MONTO)|| '>>><<<dCosto=' || DBSBFI.FUN_DEC_TO_CHAR(VI_COSTO)|| '>>><<<dCostoHistorico=' || DBSBFI.FUN_DEC_TO_CHAR(VI_COSHIST)|| '>>><<<dCtoInver=' || VI_CTOINTER || '>>><<<dImpComision=' || DBSBFI.FUN_DEC_TO_CHAR(VI_IMP_COMI)|| '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<dImpGarantia=' || '0' || '>>><<<dImpIntereses=' || DBSBFI.FUN_DEC_TO_CHAR(VI_INTERES)|| '>>><<<dImpISR=' || DBSBFI.FUN_DEC_TO_CHAR(VI_IMPUESTO)|| '>>><<<dImporte=' || DBSBFI.FUN_DEC_TO_CHAR(VI_IMPORTEC)|| '>>><<<dImpPuntualidad=' || DBSBFI.FUN_DEC_TO_CHAR(VI_PUNTUALIDAD)|| '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<dImpTitulos=' || DBSBFI.FUN_DEC_TO_CHAR(VI_IMPORTEC)|| '>>><<<dImpUtiPer=' || DBSBFI.FUN_DEC_TO_CHAR(VI_UTILPERD)|| '>>><<<dPrecio=' || DBSBFI.FUN_DEC_TO_CHAR(VI_PRECIO)|| '>>><<<dPremio=' || DBSBFI.FUN_DEC_TO_CHAR(VI_PREMIO)|| '>>><<<dTasa=' || DBSBFI.FUN_DEC_TO_CHAR(VI_PCPACTAD)|| '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<dtFecLiqui=' || VF_LIQUID || '>>><<<dTipoCambio=' || '1' || '>>><<<dTitulos=' || VI_TITULOS || '>>><<<iBajoPar=' || VI_BAJOPAR || '>>><<<iCuponEmision=' || '0' || '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<iCustodio=' || VI_CUSTODIO || '>>><<<iInstrumento=' || VI_INSTRUME || '>>><<<iMercado=' || VI_MERCADO || '>>><<<iMoneda=' || VI_MONEDA || '>>><<<iPlazo=' || VI_PLAZO || '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<lFolioReporto=' || VI_FOLIO_REP || '>>><<<lIntermediario=' || VI_INTERMED || '>>><<<lSecEmision=' || VI_SECEMIS || '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<sFormaNegociacion=' || VS_FORMANEG || '>>><<<sPizarraEmision=' || VS_PIZARRA || '>>><<<sPizarraEmisionAnterior=' || VS_PIZARRA || '>>><<<sSerieEmision=' || VS_SERIE || '>>><<<sSerieEmisionAnterior=' || VS_SERIE || '>>><<<sTipoCV=' || VS_OPERNSF || '>>>';--


--
 --
SET VS_CADENA = VS_CADENA || '<<<iCveOpera=' || VI_CVEOPERA || '>>><<<dtFecOperbur=' || VF_OPERBUR || '>>><<<sTipoDerecho=' || REPLACE( VS_TIPODERECH, ',', '//' )|| '>>>';--


--
 --
SET VI_FOLIO_CONT = 0;--


--
SET VI_TRAN_ID_TRAN_CD = NULL;--


--
SET VI_TRAN_ID_TRAN_VD = NULL;--


--
SET VI_CPRA_COMISION = 0;--


--
SET VI_CPRA_COSTO = 0;--


--
SET VI_CPRA_IMPORTE = 0;--


--
SET VI_CPRA_IVA = 0;--


--
SET VI_VTA_COMISION = 0;--


--
SET VI_VTA_COSTO = 0;--


--
SET VI_VTA_IMPORTE = 0;--


--
SET VI_VTA_IVA = 0;--


--
SET VI_VTA_COSTO_UTIL = 0;--


--
SET VI_VTA_ISR = 0;--


--
 --
 COMMIT WORK;--


--
 --
 --SI LA OPERACION PROCESADA NO ES FUTURA, SE LLAMA AL SP SP_GEN_CLASES_CONT CON FH_LIQUIDACION
 --SI LA OPERACION PROCESADA ES FUTURA, SE LLAMA AL SP P SP_GEN_CLASES_CONT CON FH_OPERACION
 --
 IF (VF_OPERBUR < VF_LIQUID 
 AND VS_OPERNSF IN('CD',
               'VD',
               'RE',
               'DE'))
OR VS_OPERNSF = 'CR'
 THEN CALL DBSBFI.SP_GEN_CLASES_CONT(
   VI_CTO,
   VI_TIPONEG,
   VI_CLASIF,
   VI_ABI_CERR,
   VS_ADMONPROP,
   VI_NIVEL1,
   VI_SCTO,
   VF_OPERBUR,
   VS_CADENA,
   PI_USUARIO,
   1,
   VS_DATOSMOV,
   VS_DETMOV,
   VI_FOLIO_CONT,
   PCH_SQLSTATE_OUT,
   PI_SQLCODE_OUT,
   PS_MSGERR_OUT
);--


--
ELSE CALL DBSBFI.SP_GEN_CLASES_CONT(
   VI_CTO,
   VI_TIPONEG,
   VI_CLASIF,
   VI_ABI_CERR,
   VS_ADMONPROP,
   VI_NIVEL1,
   VI_SCTO,
   VF_LIQUID,
   VS_CADENA,
   PI_USUARIO,
   1,
   VS_DATOSMOV,
   VS_DETMOV,
   VI_FOLIO_CONT,
   PCH_SQLSTATE_OUT,
   PI_SQLCODE_OUT,
   PS_MSGERR_OUT
);--


--
END IF;--


--
 --
 IF PS_MSGERR_OUT <> ''
OR VI_FOLIO_CONT = 0 THEN ROLLBACK WORK;--


--
 --
 /* INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       (
           SELECT
               MAX( CVE_NUM_SEC_CLAVE )+ 1
           FROM                CLAVES
           WHERE                CVE_NUM_CLAVE =- 5
       ),
       substr(
           PS_MSGERR_OUT,
           1,
           50
       ),
       VI_ITERACCION,
       VI_REG,
       CHAR( CURRENT_TIMESTAMP ),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
	*/

--
 --
SET VS_ERROR = '106 ERROR EN CONTABILIZADOR ' || PS_MSGERR_OUT;--


--
 --
 GOTO SIGUIENTE;--


--
 --
ELSE 
	/*INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       (
           SELECT
               MAX( CVE_NUM_SEC_CLAVE )+ 1
           FROM                CLAVES
           WHERE                CVE_NUM_CLAVE =- 5
       ),
       'CONTABILIZADO CORRECTAMENTE',
       VI_FOLIO_CONT,
       VI_REG,
       CHAR( CURRENT_TIMESTAMP ),
       VI_NOREG,
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
	*/

--
 --
 --RECUPERAMOS LA OPERACION CONTABLE GENERADA Y ACTUALIZAMOS EL REGISTRO CORRESPONDIENTE EN LA TABLA TFI259_OPE_FUT_IND
 --ACTUALIZANDO TANTO LA OPERACION COMO EL FOLIO CONTABLE
 --
 IF VF_OPERBUR < VF_LIQUID THEN CALL DBSBFI.SP_BUSCADATO(
   VS_DETMOV,
   'sNumOperacion',
   VS_NUMOPERACION
);--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    CD_OPER_CONT_CARGA = VS_NUMOPERACION,
   CD_FOL_CONT_CARGA = VI_FOLIO_CONT
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG;--


--
 --
 --RECUPERAMOS LOS DIFERENTES IMPORTES PARA ACTUALIZARLOS EN LA TABLA TFI259_OPE_FUT_IND
 --EN FUNCION DE SI LA OPERACION ES UNA COMPRA O VENTA
 --
 IF(
   VS_OPERNSF = 'CD'
   AND SUBSTR(
       VI_CTOINTER,
       1,
       3
   )<> 903
) THEN CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01COMISION',
   VI_CPRA_COMISION
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01COSTO',
   VI_CPRA_COSTO
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01IMPORTE',
   VI_CPRA_IMPORTE
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01IVA',
   VI_CPRA_IVA
);--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_CPRA_COMISION = VI_CPRA_COMISION
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'COMISION' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 2150
           )
           AND CCON_CTA = 2150
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_CPRA_COSTO = VI_CPRA_COSTO
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'COSTO' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 2150
           )
           AND CCON_CTA = 2150
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_CPRA_IMPORTE = VI_CPRA_IMPORTE
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'IMPORTE' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 2150
           )
           AND CCON_CTA = 2150
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_CPRA_IVA = VI_CPRA_IVA
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'IVA' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 2150
           )
           AND CCON_CTA = 2150
   );--


--
 ELSEIF(
   VS_OPERNSF = 'VD'
   AND SUBSTR(
       VI_CTOINTER,
       1,
       3
   )<> 903
) THEN CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01COMISION',
   VI_VTA_COMISION
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01COSTO',
   VI_VTA_COSTO
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01IMPORTE',
   VI_VTA_IMPORTE
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01IVA',
   VI_VTA_IVA
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01COSTO UTIL',
   VI_VTA_COSTO_UTIL
);--


--
 CALL DBSBFI.SP_BUSCADATO(
   VS_DATOSMOV,
   '01ISR',
   VI_VTA_ISR
);--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_VTA_COMISION = VI_VTA_COMISION
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'COMISION' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 1550
           )
           AND CCON_CTA = 1550
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_VTA_COSTO = VI_VTA_COSTO
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'COSTO' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 1550
           )
           AND CCON_CTA = 1550
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_VTA_IMPORTE = VI_VTA_IMPORTE
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'IMPORTE' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 1550
           )
           AND CCON_CTA = 1550
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_VTA_IVA = VI_VTA_IVA
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'IVA' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 1550
           )
           AND CCON_CTA = 1550
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_VTA_COSTO_UTIL = VI_VTA_COSTO_UTIL
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'COSTO UTIL' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 1550
           )
           AND CCON_CTA = 1550
   );--


--
 UPDATE
   GDB2PR.TFI259_OPE_FUT_IND
SET    IM_VTA_ISR = VI_VTA_ISR
WHERE    FH_CARGA = VF_UPOACTUAL
   AND CD_RECNO = VI_NOREG
   AND 'ISR' IN(
       SELECT
           DISTINCT TRIM( GUID_VALOR )
       FROM            FDGUIADET
       WHERE            TRAN_ID_TRAN IN(
               SELECT
                   DISTINCT TRAN_ID_TRAN
               FROM                    FDASIENTOS
               WHERE                    DETM_FOLIO_OP = VI_FOLIO_CONT
                   AND CCON_CTA = 1550
           )
           AND CCON_CTA = 1550
   );--


--
END IF;--


--
END IF;--


--
 --
 INSERT
   INTO        FDREDACCION
   VALUES(
       VI_FOLIO_CONT,
       Chr(39)|| VS_TIPODERECH || Chr(39)
   );--


--
 --
END IF;--


--
 --
SET VS_OPER = 'CD,VD,DE,RE,AM,AMT';--


--
 --
 IF POSSTR(
   VS_OPER,
   VS_OPERNSF
)> 0 THEN
SET VI_HAY_POS = 0;--


--
 --
SET VI_HAY_POSMSA = 0;--


--
 --
 DELETE
FROM    SESSION.HAYPOS;--


--
 --
SET VS_ENCAB = 'INSERT INTO SESSION.HAYPOS SELECT 1,COALESCE((SELECT COALESCE(CASE WHEN COALESCE(POS_POSIC_ACTUAL,0) >= 0 THEN 1 ELSE 1 END,0) FROM POSICION ';--


--
 --
SET VS_VALWHERE = ' WHERE POS_NUM_CONTRATO =' || VI_CTO || ' AND POS_SUB_CONTRATO =' || VI_SCTO || ' AND POS_NUM_ENTID_FIN =' || VI_INTERMED || ' AND POS_CONTRATO_INTER =' || VI_CTOINTER || ' AND POS_CVE_TIPO_MERCA =' || VI_MERCADO || ' AND POS_NUM_INSTRUME = ' || VI_INSTRUME;--


--
 --
SET VS_VALWHERE = VS_VALWHERE || ' AND POS_NUM_SEC_EMIS =' || VI_SECEMIS || ' AND POS_NOM_PIZARRA =''' || VS_PIZARRA || ''' AND POS_NUM_SER_EMIS =''' || VS_SERIE || ''' ),0)FROM FECCONT WITH UR';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALWHERE;--


--
 --
SET VS_ENCAB = 'INSERT INTO SESSION.HAYPOS SELECT 2,COALESCE((SELECT COALESCE(CASE WHEN COALESCE(POS_POSIC_ACTUAL,0) >= 0 THEN 1 ELSE 1 END,0) FROM POSICIONMSA ';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALWHERE;--


--
 --
 SELECT
   HAYPOSI INTO        VI_HAY_POS
   FROM        SESSION.HAYPOS
   WHERE        SEC = 1;--


--
 --
 SELECT
   HAYPOSI INTO        VI_HAY_POSMSA
   FROM        SESSION.HAYPOS
   WHERE        SEC = 2;--


--
 --
SET VS_VALINS = ' VALUES(' || VI_CTO || ',' || VI_SCTO || ',' || VI_INTERMED || ',' || VI_CTOINTER || ',' || VI_MERCADO || ',' || VI_INSTRUME || ',' || VI_SECEMIS || ',''' || VS_PIZARRA || ''',''' || VS_SERIE || ''',0,' || VI_CUSTODIO || ',' || VI_MONEDA || ',' || VI_GARANTIA || ',0,0,';--


--
 --
SET VS_VALINS = VS_VALINS || ROUND( VI_TITULOS, 0 )|| ',0,0,' || ROUND( VI_TITULOS, 0 )|| ',' || ROUND( VI_TITULOS, 0 )|| ',' || VI_GARANTIA || ',' || ROUND( VI_IMPORTEC,+ 11 )|| ',' || YEAR(PF_SISTEMA)|| ',' || MONTH(PF_SISTEMA)|| ',' || DAY(PF_SISTEMA)|| ',' || YEAR(PF_SISTEMA)|| ',' || MONTH(PF_SISTEMA)|| ',' || DAY(PF_SISTEMA)|| ',' || YEAR(PF_SISTEMA)|| ',' || MONTH(PF_SISTEMA)|| ',' || DAY(PF_SISTEMA)|| ',''ACTIVO'')';--


--
 --
SET VS_VALUPD = ' POS_ANO_ULT_MOVTO = ' || YEAR(PF_SISTEMA)|| ',POS_MES_ULT_MOVTO = ' || MONTH(PF_SISTEMA)|| ',POS_DIA_ULT_MOVTO = ' || DAY(PF_SISTEMA)|| ',POS_ANO_ULT_MOD = ' || YEAR(PF_SISTEMA)|| ',POS_MES_ULT_MOD = ' || MONTH(PF_SISTEMA)|| ',POS_DIA_ULT_MOD = ' || DAY(PF_SISTEMA)|| ',POS_CVE_ST_POSICIO = ''ACTIVO''';--


--
 --
SET VS_VALWHERE = ' WHERE POS_NUM_CONTRATO  = ' || VI_CTO || ' AND POS_SUB_CONTRATO = ' || VI_SCTO || ' AND POS_NUM_ENTID_FIN = ' || VI_INTERMED || ' AND POS_CONTRATO_INTER = ' || VI_CTOINTER || ' AND POS_CVE_TIPO_MERCA = ' || VI_MERCADO;--


--
 --
SET VS_VALWHERE = VS_VALWHERE || ' AND POS_NUM_INSTRUME = ' || VI_INSTRUME || ' AND POS_NUM_SEC_EMIS = ' || VI_SECEMIS || ' AND POS_NOM_PIZARRA = ''' || VS_PIZARRA || ''' AND POS_NUM_SER_EMIS = ''' || VS_SERIE || ''' WITH UR';--


--
 --
 IF VS_OPERNSF = 'VD'
OR VS_OPERNSF = 'RE'
OR VS_OPERNSF = 'AMT' THEN IF VI_HAY_POS > 0 THEN
SET VS_ENCAB = 'UPDATE POSICION SET ';--


--
 --
SET VS_VALUPD = VS_VALUPD || ',POS_VTAS_POSIC_PER=POS_VTAS_POSIC_PER + ' || VI_TITULOS || ',POS_VTAS_POS_EJER=POS_VTAS_POS_EJER + ' || VI_TITULOS || ',POS_COSTO_HISTORIC = POS_COSTO_HISTORIC - ' || VI_COSTO || ',POS_POSIC_ACTUAL=POS_POSIC_ACTUAL - ' || VI_TITULOS;--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALUPD || VS_VALWHERE;--


--
 --
 IF VB_HAYRETRO = TRUE THEN IF VI_HAY_POSMSA > 0 THEN
SET VS_ENCAB = 'UPDATE POSICIONMSA SET';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALUPD || VS_VALWHERE;--


--
 --
ELSE ROLLBACK WORK;--


--
 --
SET VS_ERROR = '102 NO HAY POSICION PARA VENDER EN POSICION MSA';--


--
 --
 GOTO SIGUIENTE;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
ELSE ROLLBACK WORK;--


--
 --
SET VS_ERROR = '103 NO HAY POSICION  PARA VENDER POSICION ';--


--
 --
 GOTO SIGUIENTE;--


--
 --
END IF;--


--
 --
 ELSEIF VS_OPERNSF = 'CD'
OR VS_OPERNSF = 'DE' THEN IF VI_HAY_POS <= 0 THEN
SET VS_ENCAB = 'INSERT INTO POSICION ';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
ELSE
SET VS_ENCAB = 'UPDATE POSICION SET ';--


--
 --
SET VS_VALUPD = VS_VALUPD || ',POS_CPAS_POSIC_PER=POS_CPAS_POSIC_PER + ' || VI_TITULOS || ',POS_CPAS_POS_EJER=POS_CPAS_POS_EJER + ' || VI_TITULOS || ',POS_COSTO_HISTORIC=POS_COSTO_HISTORIC + ' || ROUND( VI_IMPORTEC,+ 2 )|| ',POS_POSIC_ACTUAL=POS_POSIC_ACTUAL + ' || VI_TITULOS;--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALUPD || VS_VALWHERE;--


--
 --
END IF;--


--
 --
 IF VB_HAYRETRO = TRUE THEN IF VI_HAY_POSMSA <= 0 THEN
SET VS_ENCAB = 'INSERT INTO POSICIONMSA ';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
ELSE
SET VS_ENCAB = 'UPDATE POSICIONMSA SET ';--


--
 --
SET VS_VALUPD = VS_VALUPD || ',POS_COSTO_HISTORIC=POS_COSTO_HISTORIC + ' || ROUND( VI_COSTO,+ 2 )|| ',POS_POSIC_ACTUAL=POS_POSIC_ACTUAL + ' || VI_TITULOS;--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALUPD || VS_VALWHERE;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'VD'
OR VS_OPERNSF = 'AMT'
OR VS_OPERNSF = 'RE' THEN UPDATE
   COMPEMIS A
SET    A.CPE_TIT_DISP_COMP =(
       SELECT
           B.CPE_TIT_DISP_COMP -(
               CASE
                   WHEN B.TITULOS > B.CPE_TIT_DISP_COMP THEN B.CPE_TIT_DISP_COMP
                   ELSE B.TITULOS
               END
           )
       FROM            SESSION.UTILPERD B
       WHERE            A.CPE_SEC_DIA_COMPRA = B.CPE_SEC_DIA_COMPRA
           AND B.TITULOS > 0
   ),
   A.CPE_CVE_ST_COMPEMI =(
       SELECT
           CASE
               WHEN(
                   B.CPE_TIT_DISP_COMP -(
                       CASE
                           WHEN B.TITULOS > B.CPE_TIT_DISP_COMP THEN B.CPE_TIT_DISP_COMP
                           ELSE B.TITULOS
                       END
                   )
               )= 0 THEN 'VENDIDO'
               ELSE 'ACTIVO'
           END
       FROM            SESSION.UTILPERD B
       WHERE            A.CPE_SEC_DIA_COMPRA = B.CPE_SEC_DIA_COMPRA
           AND B.TITULOS > 0
   ),
   A.CPE_FOLIO_CANCELA = VI_FOLIO_CONT
WHERE    A.CPE_SEC_DIA_COMPRA IN(
       SELECT
           CPE_SEC_DIA_COMPRA
       FROM            SESSION.UTILPERD
       WHERE            TITULOS > 0
   );--


--
 --
 SELECT
   MAX( CPE_SEC_DIA_COMPRA ) INTO        VI_FOLCOMPRA
   FROM        SESSION.UTILPERD
   WHERE        TITULOS > 0 WITH UR;--


--
 --
 INSERT
   INTO        VENTEMIS
   VALUES(
       VI_CTO,
       VI_SCTO,
       VI_INTERMED,
       VI_CTOINTER,
       VI_MERCADO,
       VI_INSTRUME,
       VI_SECEMIS,
       PF_CONTABLE,
       VI_FOLIO_CONT,
       VI_FOLCOMPRA,
       VS_PIZARRA,
       VS_SERIE,
       0,
       VI_CUSTODIO,
       VI_MONEDA,
       ROUND( VI_PRECIO,+ 11 ),
       ROUND( VI_COSTO / VI_TITULOS,+ 11 ),
       ROUND( VI_IMPORTEC,+ 11 ),
       ROUND( VI_TITULOS, 0 ),
       PF_SISTEMA,
       PF_SISTEMA,
       'ACTIVO'
   ) WITH UR;--


--
 --
ELSE INSERT
   INTO        COMPEMIS
   VALUES(
       VI_CTO,
       VI_SCTO,
       VI_INTERMED,
       VI_CTOINTER,
       VI_MERCADO,
       VI_INSTRUME,
       VI_SECEMIS,
       PF_CONTABLE,
       VI_FOLIO_CONT,
       VS_PIZARRA,
       VS_SERIE,
       0,
       VI_CUSTODIO,
       VI_MONEDA,
       ROUND( VI_PRECIO,+ 11 ),
       ROUND( VI_IMPORTEC,+ 11 ),
       ROUND( VI_TITULOS, 0 ),
       ROUND( VI_TITULOS, 0 ),
       '0',
       PF_SISTEMA,
       PF_SISTEMA,
       'ACTIVO'
   );--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'RE' THEN IF VI_UTILPERD <> 0 THEN
SET VS_ENCAB = 'UPDATE POSICION ';--


--
 --
SET VS_VALINS = ' SET POS_COSTO_HISTORIC = POS_COSTO_HISTORIC - ' || ROUND( VI_UTILPERD,+ 2 )|| ' WHERE POS_NUM_CONTRATO=' || VI_CTO || ' AND POS_SUB_CONTRATO = ' || VI_SCTO || ' AND POS_CONTRATO_INTER = ' || VI_CTOINTER || ' AND POS_CVE_TIPO_MERCA = ' || VI_MERCADO || ' AND POS_NUM_INSTRUME = ' || VI_INSTRUME || ' AND POS_NUM_SEC_EMIS = ' || VI_SECEMIS || ' AND POS_NUM_ENTID_FIN = ' || VI_INTERMED || ' AND POS_NOM_PIZARRA = ''' || VS_PIZARRA || ''' AND POS_NUM_SER_EMIS = ''' || VS_SERIE || ''' WITH UR';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
 IF VB_HAYRETRO = TRUE THEN
SET VS_ENCAB = 'UPDATE POSICIONMSA ';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
END IF;--


--
 --
SET VI_HAY_POS = 0;--


--
 --
 SELECT
   CASE
       POS_POSIC_ACTUAL
       WHEN 0 THEN 0
       ELSE POS_COSTO_HISTORIC / POS_POSIC_ACTUAL
   END,
   POS_POSIC_ACTUAL INTO        VI_PRECIO,
       VI_HAY_POS
   FROM        POSICION
   WHERE        POS_NUM_CONTRATO = VI_CTO
       AND POS_SUB_CONTRATO = VI_SCTO
       AND POS_CONTRATO_INTER = VI_CTOINTER
       AND POS_CVE_TIPO_MERCA = VI_MERCADO
       AND POS_NUM_INSTRUME = VI_INSTRUME
       AND POS_NUM_SEC_EMIS = VI_SECEMIS
       AND POS_NUM_ENTID_FIN = VI_INTERMED
       AND POS_NOM_PIZARRA = VS_PIZARRA
       AND POS_NUM_SER_EMIS = VS_SERIE WITH UR;--


--
 --
 IF VI_HAY_POS > 0 THEN UPDATE
   COMPEMIS
SET    CPE_PRECIO_EMISION = ROUND( VI_PRECIO,+ 11 )
WHERE    CPE_NUM_CONTRATO = VI_CTO
   AND CPE_SUB_CONTRATO = VI_SCTO
   AND CPE_CONTRATO_INTER = VI_CTOINTER
   AND CPE_CVE_TIPO_MERCA = VI_MERCADO
   AND CPE_NUM_INSTRUME = VI_INSTRUME
   AND CPE_NUM_SEC_EMIS = VI_SECEMIS
   AND CPE_ENTIDAD_FIN = VI_INTERMED
   AND CPE_NOM_PIZARRA = VS_PIZARRA
   AND CPE_NUM_SERIE_EMIS = VS_SERIE
   AND CPE_CVE_ST_COMPEMI = 'ACTIVO'
   AND CPE_TIT_DISP_COMP > 0 WITH UR;--


--
 --
ELSE ROLLBACK WORK;--


--
 --
SET VS_ERROR = '105 NO HAY POSICION PARA AJUSTAR EL PRECIO ';--


--
 --
 GOTO SIGUIENTE;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'CR' THEN IF VI_TITULOS <> 0 THEN
SET VI_PRECIO = VI_IMPORTEC / VI_TITULOS;--


--
 --
ELSE
SET VI_PRECIO = 0;--


--
 --
END IF;--


--
 --
SET VS_ENCAB = 'INSERT INTO FDCONREPOR VALUES(';--


--
 --
SET VS_VALINS = VI_CTO || ',' || VI_SCTO || ',' || VI_MONEDA || ',1,' || VI_INTERMED || ',' || VI_CTOINTER || ',' || VI_FOLIO_REP || ',' || VI_FOLIO_CONT || ',' || VI_PLAZO || ',' || VI_MERCADO || ',' || VI_INSTRUME || ',' || VI_SECEMIS || ',' || VI_TITULOS;--


--
 --
SET VS_VALINS = VS_VALINS || ',' || VI_PRECIO || ',' || VI_IMPORTEC || ',' || VI_PCPACTAD || ',' || VI_PREMIO || ',''' || VF_VENCIMIENTO || ''',0,''' || VF_VENCIMIENTO || ''',''' || PF_CONTABLE || ''',''' || PF_CONTABLE || ''',''ACTIVO''' || ',' || VI_CUSTODIO || ',' || VS_PAPEL || ',NULL,0)';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
 IF VB_HAYRETRO = TRUE THEN
SET VS_ENCAB = 'INSERT INTO FDCONREPORMSA VALUES( ';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'VR' THEN
SET VS_ENCAB = 'UPDATE FDCONREPOR ';--


--
 --
SET VS_VALINS = ' SET CRE_CVE_ST_CONREPO=''AMORTIZADO'',CRE_FOLIO_AMORT =' || VI_FOLIO_CONT || ' WHERE CRE_FOLIO_REPORTO = ' || VI_FOLIO_REP || ' WITH UR';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
 IF VB_HAYRETRO = TRUE THEN
SET VS_ENCAB = 'UPDATE FDCONREPORMSA';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALINS;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF = 'AMC'
AND PI_USUARIO = 999 THEN SELECT
   CASE
       POS_POSIC_ACTUAL
       WHEN 0 THEN 0
       ELSE(
           POS_COSTO_HISTORIC - VI_MONTO
       )/ POS_POSIC_ACTUAL
   END,
   POS_POSIC_ACTUAL INTO        VI_PRECIO,
       VI_TITULOS
   FROM        POSICION
   WHERE        POS_NUM_CONTRATO = VI_CTO
       AND POS_SUB_CONTRATO = VI_SCTO
       AND POS_CONTRATO_INTER = VI_CTOINTER
       AND POS_CVE_TIPO_MERCA = VI_MERCADO
       AND POS_NUM_INSTRUME = VI_INSTRUME
       AND POS_NUM_SEC_EMIS = VI_SECEMIS
       AND POS_NUM_ENTID_FIN = VI_INTERMED
       AND POS_NOM_PIZARRA = VS_PIZARRA
       AND POS_NUM_SER_EMIS = VS_SERIE WITH UR;--


--
 --
 IF VI_TITULOS > 0 THEN UPDATE
   COMPEMIS
SET    CPE_PRECIO_EMISION = VI_PRECIO
WHERE    CPE_NUM_CONTRATO = VI_CTO
   AND CPE_SUB_CONTRATO = VI_SCTO
   AND CPE_CONTRATO_INTER = VI_CTOINTER
   AND CPE_CVE_TIPO_MERCA = VI_MERCADO
   AND CPE_NUM_INSTRUME = VI_INSTRUME
   AND CPE_NUM_SEC_EMIS = VI_SECEMIS
   AND CPE_ENTIDAD_FIN = VI_INTERMED
   AND CPE_NOM_PIZARRA = VS_PIZARRA
   AND CPE_NUM_SERIE_EMIS = VS_SERIE
   AND CPE_CVE_ST_COMPEMI = 'ACTIVO'
   AND CPE_TIT_DISP_COMP > 0 WITH UR;--


--
 --
END IF;--


--
 --
SET VS_ENCAB = 'UPDATE POSICION SET POS_COSTO_HISTORIC=POS_COSTO_HISTORIC - ' || VI_MONTO;--


--
 --
SET VS_VALWHERE = ' WHERE POS_NUM_CONTRATO = ' || VI_CTO || ' AND POS_SUB_CONTRATO = ' || VI_SCTO || ' AND POS_NUM_ENTID_FIN = ' || VI_INTERMED || ' AND POS_CONTRATO_INTER = ' || VI_CTOINTER || ' AND POS_CVE_TIPO_MERCA = ' || VI_MERCADO || ' AND POS_NUM_INSTRUME = ' || VI_INSTRUME;--


--
 --
SET VS_VALWHERE = VS_VALWHERE || ' AND POS_NUM_SEC_EMIS = ' || VI_SECEMIS || ' AND POS_NOM_PIZARRA = ''' || VS_PIZARRA || ''' AND POS_NUM_SER_EMIS = ''' || VS_SERIE || ''' WITH UR';--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALWHERE;--


--
 --
 IF VB_HAYRETRO = TRUE THEN
SET VS_ENCAB = 'UPDATE POSICIONMSA SET POS_COSTO_HISTORIC=POS_COSTO_HISTORIC - ' || VI_MONTO;--


--
 --
 EXECUTE IMMEDIATE VS_ENCAB || VS_VALWHERE;--


--
 --
END IF;--


--
 --
END IF;--


--
 --
 IF VS_OPERNSF <> 'PI' THEN IF VI_UTILPERD >= 0 THEN
SET VI_UTILIDAD = VI_UTILPERD;--


--
 --
SET VI_PERDIDA = 0;--


--
 --
ELSE
SET VI_PERDIDA = VI_UTILPERD *- 1;--


--
 --
SET VI_UTILIDAD = 0;--


--
 --
END IF;--


--
 --
 INSERT
   INTO        DETVALOR
   VALUES(
       VI_FOLIO_CONT,
       '',
       0,
       0,
       0,
       0,
       VI_CTO,
       VI_SCTO,
       VI_INTERMED,
       VI_CTOINTER,
       VI_MERCADO,
       VI_INSTRUME,
       VI_SECEMIS,
       VS_PIZARRA,
       VS_SERIE,
       0,
       VI_PRECIO,
       VI_TITULOS,
       VI_IMPORTEC,
       0,
       0,
       VI_PCPACTAD,
       VI_PLAZO,
       VI_FOLIO_REP,
       VI_PREMIO,
       VS_FORMANEG,
       VS_FORMANEG,
       YEAR(PF_SISTEMA),
       MONTH(PF_SISTEMA),
       DAY(PF_SISTEMA),
       YEAR(PF_SISTEMA),
       MONTH(PF_SISTEMA),
       DAY(PF_SISTEMA),
       'ACTIVO',
       VI_INTERES,
       VI_IMPUESTO,
       ' ',
       0,
       'X',
       VI_IMP_COMI,
       VI_UTILIDAD,
       VI_PERDIDA,
       VS_PIZARRA,
       VS_SERIE,
       0,
       VI_MONEDA,
       0,
       1.00000000
   );--


--
 --
END IF;--


--
 --
 UPDATE
   FID_INV_UPD_OPERACION
SET    UPO_SMSGERR_FIDUINVER = '',
   UPO_STATUS_REC = 0,
   UPO_FOLIO_FIDUINVER = VI_FOLIO_CONT,
   UPO_FPROCESO = CURRENT_DATE
WHERE    UPO_FACTUALIZA = VF_UPOACTUAL
   AND UPO_RECNO = VI_NOREG WITH UR;--


--
 --
 UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR = 'CORRECTO',
   ST_REG = 0
WHERE    NU_SEC = VI_REG WITH UR;--


--
 --
SET VS_ERROR = '';--


--
 --
END IF;--


--
 --
 SIGUIENTE:IF VS_ERROR <> ''
AND VS_ERROR <> 'SEGUNDA VUELTA' THEN UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR = VS_ERROR,
   ST_REG = INTEGER(
       SUBSTR(
           VS_ERROR,
           1,
           3
       )
   )
WHERE    NU_SEC = VI_REG WITH UR;--


--
 --
 UPDATE
   FID_INV_UPD_OPERACION
SET    UPO_SMSGERR_FIDUINVER = VS_ERROR,
   UPO_STATUS_REC = SUBSTR(
       VS_ERROR,
       1,
       3
   ),
   UPO_FPROCESO = CURRENT_DATE
WHERE    UPO_FACTUALIZA = VF_UPOACTUAL
   AND UPO_RECNO = VI_NOREG WITH UR;--


--
 --
END IF;--


--
 --
 IF VS_ERROR = 'SEGUNDA VUELTA' THEN UPDATE
   SESSION.PROC_NOCT
SET    TX_ERROR = VS_ERROR
WHERE    NU_SEC = VI_REG WITH UR;--


--
 --
END IF;--


--
 SELECT
   NB_FIN INTO        VS_CONTROL
   FROM        TFI097_CLAVEFIN
   WHERE        CD_FIN = 32
       AND NU_SECUENCIAL = 0
       AND TP_FIN = 0 WITH UR;--


--
 --
 IF VS_CONTROL = 'CANCELAR' THEN
SET VI_REG = VI_TOTREG;--


--
 --
 INSERT
   INTO        BITACORA
   VALUES(
       CURRENT TIMESTAMP,
       'MAESTRA',
       PI_USUARIO,
       'BATCH 1',
       'SP_FIDUINVER',
       'CANCELACION MANUAL PROCESO DE INVERSIONES BURSATILES EN EL REGISTRO' || CHAR( VI_NOREG )
   );--


--
 --
END IF;--


--
 --
 COMMIT WORK;--


--
 --
SET VI_REG = VI_REG + 1;--


--
 --
SET PS_MSGERR_OUT = '';--


--
SET VS_ERROR = '';--


--
END WHILE;--


--
 --
SET VI_ITERACCION = VI_ITERACCION + 1;--


--
 --
END WHILE;--


--
 DELETE
FROM    GDB2PR.TFI259_OPE_FUT_IND
WHERE    CD_OPER_CONT_CARGA IS NULL
   AND CD_FOL_CONT_CARGA IS NULL;--


--
 --
ELSE 
	/*INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       (
           SELECT
               COALESCE(
                   MAX( CVE_NUM_SEC_CLAVE ),
                   0
               )+ 1
           FROM                CLAVES
           WHERE                CVE_NUM_CLAVE =- 5
       ),
       'NO HAY DATOS',
       0.00,
       0.00,
       CHAR( CURRENT_TIMESTAMP ),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
   */


--
 --
 INSERT
   INTO        BITACORA
   VALUES(
       CURRENT TIMESTAMP,
       'MAESTRA',
       PI_USUARIO,
       'BATCH 1',
       'SP_FIDUINVER',
       'NO HAY DATOS EN TABLA FID_INV_UPD_OPERACION QUE CUMPLAN CON LAS CONDICIONES'
   );--


--
 --
SET PS_MSGERR_OUT = 'NO HAY DATOS EN TABLA FID_INV_UPD_OPERACION QUE CUMPLAN CON LAS CONDICIONES';--


--
 --
 RETURN - 1;--


--
 --
END IF;--


--
 --
ELSE 
/*INSERT
   INTO        GDB2PR.CLAVES
   VALUES(
       - 5,
       (
           SELECT
               COALESCE(
                   MAX( CVE_NUM_SEC_CLAVE ),
                   0
               )+ 1
           FROM                CLAVES
           WHERE                CVE_NUM_CLAVE =- 5
       ),
       'SE MANDO RUTINA QUE NO ES POR LOTES',
       0.00,
       0.00,
       CHAR( CURRENT_TIMESTAMP ),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       YEAR(CURRENT_DATE),
       MONTH(CURRENT_DATE),
       DAY(CURRENT_DATE),
       'ACTIVO'
   );--
	*/

--
 --
 INSERT
   INTO        BITACORA
   VALUES(
       CURRENT TIMESTAMP,
       'MAESTRA',
       PI_USUARIO,
       'BATCH 1',
       'SP_FIDUINVER',
       'NO SE PIDIO EJECUTAR PROCESO BATCH NOCTURNO'
   );--


--
 --
SET PS_MSGERR_OUT = 'NO SE PIDIO EJECUTAR PROCESO BATCH NOCTURNO';--


--
 --
 RETURN - 1;--


--
 --
END IF;--


--
 --
 SALIDA:IF PS_MSGERR_OUT <> '' THEN RETURN - 1;--


--
 --
END IF;--


--
 --
 DROP
   TABLE
       SESSION.PROC_NOCT;--


--
 --
 DROP
   TABLE
       SESSION.UTILPERD;--


--
 --
END P1 