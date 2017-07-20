module Dampf.Internal.ConfigFile.Pretty
  ( pShowDampfConfig
  ) where

import           Control.Lens
import qualified Data.Map.Strict as Map
import           Text.PrettyPrint

import           Dampf.Internal.ConfigFile.Types


pShowDampfConfig :: DampfConfig -> String
pShowDampfConfig = render . hang (text "Config File:") 4 . pprDampfConfig


pprDampfConfig :: DampfConfig -> Doc
pprDampfConfig cfg = vcat
    [ pprLiveCertificate l
    , pprDatabaseServer d
    ]
  where
    l = cfg ^. liveCertificate
    d = cfg ^. postgres


pprLiveCertificate :: Maybe FilePath -> Doc
pprLiveCertificate (Just l) = vcat
    [ text "Live Certificate:"
    , text ""
    , nest 4 (text l)
    , text ""
    ]

pprLiveCertificate Nothing  = empty


pprDatabaseServer :: Maybe PostgresConfig -> Doc
pprDatabaseServer (Just s) = vcat
    [ text "Database Server:"
    , text ""
    , nest 4 (pprPostgresConfig s)
    , text ""
    ]

pprDatabaseServer Nothing  = empty


pprPostgresConfig :: PostgresConfig -> Doc
pprPostgresConfig cfg = vcat
    [ text "host:" <+> text h
    , text "port:" <+> int p
    , text "users:"
    , nest 4 (pprMap u)
    ]
  where
    h = cfg ^. host
    p = cfg ^. port
    u = cfg ^. users . to Map.toList


pprMap :: (Show a) => [(a, a)] -> Doc
pprMap kvs = vcat
    $ fmap (\(k, v) -> text (show k) <> colon <+> text (show v)) kvs

