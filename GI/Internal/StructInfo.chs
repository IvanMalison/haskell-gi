
module GI.Internal.StructInfo
    ( structInfoFields
    , structInfoIsGTypeStruct
    -- XXX: Implement these.
    -- , structInfoMethods
    -- , structInfoSize
    -- , structInfoAlignment
    )
where

import Control.Applicative ((<$>))
import Foreign hiding (unsafePerformIO)
import Foreign.C
import System.IO.Unsafe (unsafePerformIO)

import GI.Util (getList)

{# import GI.Internal.Types #}

#include <girepository.h>

{# context prefix="g_struct_info" #}

-- Because all the C types are synonyms, c2hs picks the last one...
stupidCast :: StructInfoClass sic => sic -> Ptr ()
stupidCast si = castPtr p
  where (StructInfo p) = structInfo si

structInfoFields :: StructInfoClass sic => sic -> [FieldInfo]
structInfoFields si = unsafePerformIO $
    map (FieldInfo <$> castPtr) <$>
    getList {# call get_n_fields #} {# call get_field #} (stupidCast si)

structInfoIsGTypeStruct :: StructInfoClass sic => sic -> Bool
structInfoIsGTypeStruct si = unsafePerformIO $ (/= 0) <$>
    {# call is_gtype_struct #} (stupidCast si)