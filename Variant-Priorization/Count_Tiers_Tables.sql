-- All count
SELECT COUNT(*)
FROM variants 

-- Artifacts count
SELECT COUNT(*)
FROM variants 
WHERE comments = 'artifact';

-- Benign count
SELECT COUNT(*)
FROM variants 
WHERE comments = 'benign';

-- Tier 1 count
SELECT COUNT(*)
FROM variants 
WHERE comments = 'tier1';

-- Tier 2 count
SELECT COUNT(*)
FROM variants 
WHERE comments = 'tier2';

-- Tier 3 count
SELECT COUNT(*)
FROM variants 
WHERE comments = 'tier3';

-- Print Tier
SELECT gene_hgnc, chr, loc, HGVS_cDNA, HGVS_protein, consequence,variation_type
FROM variants
WHERE comments = 'benign'
ORDER BY vscore DESC;


