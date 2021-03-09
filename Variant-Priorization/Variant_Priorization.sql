-- Artifacts 
UPDATE variants
SET comments = "artifact"
WHERE homopolymer LIKE '%yes%' AND
    (variation_type LIKE '%deletion%' OR variation_type LIKE '%insertion%' );

-- Likely Benign add consequence
UPDATE variants
SET comments = "benign"
WHERE (GMAF_freq >= 1 OR gnomAD >= 1 OR gnomAD_NFE >=1) AND
    clinvar_clinical_significance NOT LIKE '%_athogenic%' AND
    cosmic_id NOT LIKE '%PATHOGENIC%' AND
    comments NOT LIKE 'artifact';


-- Tier 1
UPDATE variants
SET comments = "tier1"
WHERE (clinvar_clinical_significance LIKE '%_athogenic%' OR cosmic_id LIKE '%PATHOGENIC%') AND
    (tumorportal IS NOT NULL OR role_driver IS NOT NULL OR kegg_data IS NOT NULL) AND 
    (pfam IS NOT NULL OR interpro IS NOT NULL) AND
    (functional_impact_prediction LIKE '%damaging%' OR functional_impact_prediction LIKE '%deleterious%') AND
    vscore >= 0.4 AND
    comments IS NOT 'artifact' AND 
    comments IS NOT 'benign';


-- Tier 2
UPDATE variants
SET comments = "tier2"
WHERE (clinvar_clinical_significance LIKE '%_athogenic%' OR cosmic_id LIKE '%PATHOGENIC%') AND
    ((tumorportal IS NOT NULL OR role_driver IS NOT NULL OR kegg_data IS NOT NULL) OR 
    (pfam IS NOT NULL OR interpro IS NOT NULL)) AND
    (functional_impact_prediction LIKE '%damaging%' OR functional_impact_prediction LIKE '%deleterious%') AND
    vscore >= 0.4 AND
    comments IS NOT 'artifact' AND 
    comments IS NOT 'benign' AND
    comments IS NOT 'tier1';

UPDATE variants
SET comments = "tier2"
WHERE (clinvar_clinical_significance LIKE '%_athogenic%' OR cosmic_id LIKE '%PATHOGENIC%') AND
    ((tumorportal IS NOT NULL OR role_driver IS NOT NULL OR kegg_data IS NOT NULL) OR 
    (functional_impact_prediction LIKE '%damaging%' OR functional_impact_prediction LIKE '%deleterious%')) AND
    (pfam IS NOT NULL OR interpro IS NOT NULL) AND
    vscore >= 0.4 AND
    comments IS NOT 'artifact' AND 
    comments IS NOT 'benign' AND
    comments IS NOT 'tier1' AND
    comments IS NOT 'tier2';

UPDATE variants
SET comments = "tier2"
WHERE (clinvar_clinical_significance LIKE '%_athogenic%' OR cosmic_id LIKE '%PATHOGENIC%') AND
    ((pfam IS NOT NULL OR interpro IS NOT NULL) OR 
    (functional_impact_prediction LIKE '%damaging%' OR functional_impact_prediction LIKE '%deleterious%')) AND
    (tumorportal IS NOT NULL OR role_driver IS NOT NULL OR kegg_data IS NOT NULL) AND
    vscore >= 0.4 AND
    comments IS NOT 'artifact' AND 
    comments IS NOT 'benign' AND
    comments IS NOT 'tier1' AND
    comments IS NOT 'tier2';

-- Tier 3
UPDATE variants
SET comments = "tier3"
WHERE comments IS NOT 'artifact' AND 
    comments IS NOT 'benign' AND
    comments IS NOT 'tier1' AND
    comments IS NOT 'tier2';

SELECT gene_hgnc, loc, vscore, comments
FROM variants
WHERE comments = 'tier3'
ORDER BY vscore DESC;

SELECT COUNT(*)
FROM variants
WHERE comments = 'tier3';






