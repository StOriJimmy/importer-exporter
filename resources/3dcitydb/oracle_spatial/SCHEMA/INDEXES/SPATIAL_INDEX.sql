-- SPATIAL_INDEX.sql
--
-- Authors:     Prof. Dr. Thomas H. Kolbe <thomas.kolbe@tum.de>
--              Gerhard König <gerhard.koenig@tu-berlin.de>
--              Claus Nagel <claus.nagel@tu-berlin.de>
--              Alexandra Stadler <stadler@igg.tu-berlin.de>
--
-- Copyright:   (c) 2007-2008  Institute for Geodesy and Geoinformation Science,
--                             Technische Universit�t Berlin, Germany
--                             http://www.igg.tu-berlin.de
--
--              This skript is free software under the LGPL Version 2.1.
--              See the GNU Lesser General Public License at
--              http://www.gnu.org/copyleft/lgpl.html
--              for more details.
-------------------------------------------------------------------------------
-- About:
--
--
-------------------------------------------------------------------------------
--
-- ChangeLog:
--
-- Version | Date       | Description                               | Author
-- 2.0.0     2007-11-23   release version                             TKol
--                                                                    GKoe
--                                                                    CNag
--
--// ENTRIES INTO USER_SDO_GEOM_METADATA WITH BOUNDING VOLUME WITH 10000km EXTENT FOR X,Y AND 11km FOR Z

SET SERVEROUTPUT ON
SET FEEDBACK ON

ALTER SESSION set NLS_TERRITORY='AMERICA';
ALTER SESSION set NLS_LANGUAGE='AMERICAN';

-- Fetch SRID from the the table DATABASE_SRS

VARIABLE SRID NUMBER;
BEGIN
  SELECT SRID INTO :SRID FROM DATABASE_SRS;
END;
/

-- Transfer the value from the bind variable :SRID to the substitution variable &SRSNO
column mc new_value SRSNO print
select :SRID mc from dual;

prompt Used SRID for spatial indexes: &SRSNO 


DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITYOBJECT' AND COLUMN_NAME='ENVELOPE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITYOBJECT', 'ENVELOPE', 
    MDSYS.SDO_DIM_ARRAY 
    (
       MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);
  
-- The following spatial index is inactive (commented out), because 
-- column CITYOBJECT_GENERICATTRIB.GEOMVAL can be assigned 2D or 3D geometries. 
-- If there would be created a spatial index, this would fix 
-- dimensionality either to 2D or 3D.

--DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITYOBJECT_GENERICATTRIB' AND COLUMN_NAME='GEOMVAL';
--INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
--  VALUES ('CITYOBJECT_GENERICATTRIB', 'GEOMVAL', 
--    MDSYS.SDO_DIM_ARRAY 
--      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
--       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005), 
--	   MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='SURFACE_GEOMETRY' AND COLUMN_NAME='GEOMETRY';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('SURFACE_GEOMETRY', 'GEOMETRY', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) ,  &SRSNO);       

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BREAKLINE_RELIEF' AND COLUMN_NAME='RIDGE_OR_VALLEY_LINES';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BREAKLINE_RELIEF', 'RIDGE_OR_VALLEY_LINES', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)), &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BREAKLINE_RELIEF' AND COLUMN_NAME='BREAK_LINES';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BREAKLINE_RELIEF', 'BREAK_LINES', 
    MDSYS.SDO_DIM_ARRAY ( MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='MASSPOINT_RELIEF' AND COLUMN_NAME='RELIEF_POINTS';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('MASSPOINT_RELIEF', 'RELIEF_POINTS', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);
      
DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='ORTHOPHOTO_IMP' AND COLUMN_NAME='FOOTPRINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('ORTHOPHOTO_IMP', 'FOOTPRINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005)),  &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='TIN_RELIEF' AND COLUMN_NAME='STOP_LINES';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('TIN_RELIEF', 'STOP_LINES', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='TIN_RELIEF' AND COLUMN_NAME='BREAK_LINES';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('TIN_RELIEF', 'BREAK_LINES', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='TIN_RELIEF' AND COLUMN_NAME='CONTROL_POINTS';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('TIN_RELIEF', 'CONTROL_POINTS', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)),  &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD0_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD0_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD1_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD1_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD2_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD2_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD3_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD3_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD4_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD4_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD0_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD0_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD0_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD0_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD1_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD1_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD2_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD2_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD3_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD3_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='GENERIC_CITYOBJECT' AND COLUMN_NAME='LOD4_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('GENERIC_CITYOBJECT', 'LOD4_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD1_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD1_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD2_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD2_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD3_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD3_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD4_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD4_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD2_MULTI_CURVE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD2_MULTI_CURVE', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD3_MULTI_CURVE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD3_MULTI_CURVE', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING' AND COLUMN_NAME='LOD4_MULTI_CURVE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING', 'LOD4_MULTI_CURVE', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='BUILDING_FURNITURE' AND COLUMN_NAME='LOD4_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('BUILDING_FURNITURE', 'LOD4_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD1_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD1_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD2_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD2_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD3_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD3_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD4_TERRAIN_INTERSECTION';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD4_TERRAIN_INTERSECTION', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD1_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD1_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD2_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD2_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD3_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD3_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITY_FURNITURE' AND COLUMN_NAME='LOD4_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITY_FURNITURE', 'LOD4_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITYMODEL' AND COLUMN_NAME='ENVELOPE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITYMODEL', 'ENVELOPE', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='CITYOBJECTGROUP' AND COLUMN_NAME='GEOMETRY';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('CITYOBJECTGROUP', 'GEOMETRY', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='RELIEF_COMPONENT' AND COLUMN_NAME='EXTENT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('RELIEF_COMPONENT', 'EXTENT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005)), &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='SURFACE_DATA' AND COLUMN_NAME='GT_REFERENCE_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('SURFACE_DATA', 'GT_REFERENCE_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='TRANSPORTATION_COMPLEX' AND COLUMN_NAME='LOD0_NETWORK';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('TRANSPORTATION_COMPLEX', 'LOD0_NETWORK', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='SOLITARY_VEGETAT_OBJECT' AND COLUMN_NAME='LOD1_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('SOLITARY_VEGETAT_OBJECT', 'LOD1_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='SOLITARY_VEGETAT_OBJECT' AND COLUMN_NAME='LOD2_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('SOLITARY_VEGETAT_OBJECT', 'LOD2_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='SOLITARY_VEGETAT_OBJECT' AND COLUMN_NAME='LOD3_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('SOLITARY_VEGETAT_OBJECT', 'LOD3_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='SOLITARY_VEGETAT_OBJECT' AND COLUMN_NAME='LOD4_IMPLICIT_REF_POINT';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('SOLITARY_VEGETAT_OBJECT', 'LOD4_IMPLICIT_REF_POINT', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='WATERBODY' AND COLUMN_NAME='LOD0_MULTI_CURVE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('WATERBODY', 'LOD0_MULTI_CURVE', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);

DELETE FROM USER_SDO_GEOM_METADATA WHERE TABLE_NAME='WATERBODY' AND COLUMN_NAME='LOD1_MULTI_CURVE';
INSERT INTO USER_SDO_GEOM_METADATA (TABLE_NAME, COLUMN_NAME, DIMINFO, SRID) 
  VALUES ('WATERBODY', 'LOD1_MULTI_CURVE', 
    MDSYS.SDO_DIM_ARRAY 
      (MDSYS.SDO_DIM_ELEMENT('X', 0.000, 10000000.000, 0.0005), 
       MDSYS.SDO_DIM_ELEMENT('Y', 0.000, 10000000.000, 0.0005),  
       MDSYS.SDO_DIM_ELEMENT('Z', -1000, 10000, 0.0005)) , &SRSNO);


--// CREATE INDEX STATEMENTS

-- CITYOBJECT_ENVELOPE
CREATE INDEX CITYOBJECT_SPX on CITYOBJECT(ENVELOPE) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- inactive (see comment above about CITYOBJECT_GENERICATTRIB.GEOMVAL
-- CREATE INDEX GENERICATTRIB_SPX on CITYOBJECT_GENERICATTRIB(GEOMVAL) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- SURFACE_GEOMETRY
CREATE INDEX SURFACE_GEOM_SPX on SURFACE_GEOMETRY(GEOMETRY) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BREAKLINE_RIDGE_OR_VALLEY_LINES
CREATE INDEX BREAKLINE_RID_SPX on BREAKLINE_RELIEF(RIDGE_OR_VALLEY_LINES) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BREAKLINE_BREAK_LINES
CREATE INDEX BREAKLINE_BREAK_SPX on BREAKLINE_RELIEF(BREAK_LINES) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- MASSPOINT_RELIEF
CREATE INDEX MASSPOINT_REL_SPX on MASSPOINT_RELIEF(RELIEF_POINTS) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- ORTHOPHOTO_IMP
CREATE INDEX ORTHOPHOTO_IMP_SPX on ORTHOPHOTO_IMP(FOOTPRINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- RELIEF_STOP_LINES
CREATE INDEX TIN_RELF_STOP_SPX on TIN_RELIEF(STOP_LINES) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- TIN_RELIEF_BREAK_LINES
CREATE INDEX TIN_RELF_BREAK_SPX on TIN_RELIEF(BREAK_LINES) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- TIN RELIEF_CONTROL_POINTS
CREATE INDEX TIN_RELF_CRTLPTS_SPX on TIN_RELIEF(CONTROL_POINTS) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD0_TERR
CREATE INDEX GENERICCITY_LOD0TERR_SPX on GENERIC_CITYOBJECT(LOD0_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD1_TERR
CREATE INDEX GENERICCITY_LOD1TERR_SPX on GENERIC_CITYOBJECT(LOD1_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD2_TERR
CREATE INDEX GENERICCITY_LOD2TERR_SPX on GENERIC_CITYOBJECT(LOD2_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD3_TERR
CREATE INDEX GENERICCITY_LOD3TERR_SPX on GENERIC_CITYOBJECT(LOD3_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD4_TERR
CREATE INDEX GENERICCITY_LOD4TERR_SPX on GENERIC_CITYOBJECT(LOD4_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD1_REF_POINT
CREATE INDEX GENERICCITY_LOD1REFPNT_SPX on GENERIC_CITYOBJECT(LOD1_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD2_REF_POINT
CREATE INDEX GENERICCITY_LOD2REFPNT_SPX on GENERIC_CITYOBJECT(LOD2_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD3_REF_POINT
CREATE INDEX GENERICCITY_LOD3REFPNT_SPX on GENERIC_CITYOBJECT(LOD3_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- GENERIC_CITYOBJECT_LOD4_REF_POINT
CREATE INDEX GENERICCITY_LOD4REFPNT_SPX on GENERIC_CITYOBJECT(LOD4_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD1_TERR
CREATE INDEX BUILDING_LOD1TERR_SPX on BUILDING(LOD1_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD2_TERR
CREATE INDEX BUILDING_LOD2TERR_SPX on BUILDING(LOD2_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD3_TERR
CREATE INDEX BUILDING_LOD3TERR_SPX on BUILDING(LOD3_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD4_TERR
CREATE INDEX BUILDING_LOD4TERR_SPX on BUILDING(LOD4_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD2_MULTI
CREATE INDEX BUILDING_LOD2MULTI_SPX on BUILDING(LOD2_MULTI_CURVE) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD3_MULTI
CREATE INDEX BUILDING_LOD3MULTI_SPX on BUILDING(LOD3_MULTI_CURVE) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_LOD4_MULTI
CREATE INDEX BUILDING_LOD4MULTI_SPX on BUILDING(LOD4_MULTI_CURVE) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- BUILDING_FURNITURE_LOD4_REF_POINT
CREATE INDEX BLDG_FURN_LOD4REFPT_SPX on BUILDING_FURNITURE(LOD4_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD1_TERR
CREATE INDEX CITY_FURN_LOD1TERR_SPX on CITY_FURNITURE(LOD1_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD2_TERR
CREATE INDEX CITY_FURN_LOD2TERR_SPX on CITY_FURNITURE(LOD2_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD3_TERR
CREATE INDEX CITY_FURN_LOD3TERR_SPX on CITY_FURNITURE(LOD3_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD4_TERR
CREATE INDEX CITY_FURN_LOD4TERR_SPX on CITY_FURNITURE(LOD4_TERRAIN_INTERSECTION) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD1_REF_POINT
CREATE INDEX CITY_FURN_LOD1REFPNT_SPX on CITY_FURNITURE(LOD1_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD2_REF_POINT
CREATE INDEX CITY_FURN_LOD2REFPNT_SPX on CITY_FURNITURE(LOD2_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD3_REF_POINT
CREATE INDEX CITY_FURN_LOD3REFPNT_SPX on CITY_FURNITURE(LOD3_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITY_FURNITURE_LOD4_REF_POINT
CREATE INDEX CITY_FURN_LOD4REFPNT_SPX on CITY_FURNITURE(LOD4_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITYMODEL
CREATE INDEX CITYMODEL_SPX on CITYMODEL(ENVELOPE) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- CITYOBJECTGROUP
CREATE INDEX CITYOBJECTGROUP_SPX on CITYOBJECTGROUP(GEOMETRY) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- RELIEF_COMPONENT
CREATE INDEX RELIEF_COMPONENT_SPX on RELIEF_COMPONENT(EXTENT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- SOLITARY_VEGETAT_OBJECT_LOD1_REF_POINT
CREATE INDEX SOL_VEG_OBJ_LOD1REFPT_SPX on SOLITARY_VEGETAT_OBJECT(LOD1_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- SOLITARY_VEGETAT_OBJECT_LOD2_REF_POINT
CREATE INDEX SOL_VEG_OBJ_LOD2REFPT_SPX on SOLITARY_VEGETAT_OBJECT(LOD2_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- SOLITARY_VEGETAT_OBJECT_LOD3_REF_POINT
CREATE INDEX SOL_VEG_OBJ_LOD3REFPT_SPX on SOLITARY_VEGETAT_OBJECT(LOD3_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- SOLITARY_VEGETAT_OBJECT_LOD4_REF_POINT
CREATE INDEX SOL_VEG_OBJ_LOD4REFPT_SPX on SOLITARY_VEGETAT_OBJECT(LOD4_IMPLICIT_REF_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- SURFACE_DATA
CREATE INDEX SURFACE_DATA_SPX on SURFACE_DATA(GT_REFERENCE_POINT) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- TRANSPORTATION_COMPLEX
CREATE INDEX TRANSPORTATION_COMPLEX_SPX on TRANSPORTATION_COMPLEX(LOD0_NETWORK) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- WATERBODY_LOD0_MULTI_CURVE
CREATE INDEX WATERBODY_LOD0MULTI_SPX on WATERBODY(LOD0_MULTI_CURVE) INDEXTYPE is MDSYS.SPATIAL_INDEX;

-- WATERBODY_LOD1_MULTI_CURVE
CREATE INDEX WATERBODY_LOD1MULTI_SPX on WATERBODY(LOD1_MULTI_CURVE) INDEXTYPE is MDSYS.SPATIAL_INDEX;