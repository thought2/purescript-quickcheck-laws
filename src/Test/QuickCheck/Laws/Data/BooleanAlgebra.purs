module Test.QuickCheck.Laws.Data.BooleanAlgebra where

import Prelude
    
import Control.Monad.Eff
import Control.Monad.Eff.Console (log)
import Test.QuickCheck (QC(..), quickCheck)
import Test.QuickCheck.Arbitrary (Arbitrary, Coarbitrary)
import Type.Proxy (Proxy())

-- | - Complemented:
-- |   - `not a || a == top`
-- |   - `not a && a == bottom`
-- | - Double negation:
-- |   - `not <<< not == id`
checkBooleanAlgebra :: forall a. (Arbitrary a, Eq a, BooleanAlgebra a) => Proxy a -> QC Unit
checkBooleanAlgebra _ = do

  log "Checking 'Complemented' law for ComplementedLattice"
  quickCheck complemented

  log "Checking 'Double negation' law for ComplementedLattice"
  quickCheck doubleNegation

  log "Checking 'Identity' law for BoundedLattice"
  quickCheck identity

  log "Checking 'Annihiliation' law for BoundedLattice"
  quickCheck annihiliation

  log "Checking 'Distributivity' law for DistributiveLattice"
  quickCheck distributivity
  
  log "Checking 'Associativity' law for Lattice"
  quickCheck associativity

  log "Checking 'Commutativity' law for Lattice"
  quickCheck commutativity

  log "Checking 'Absorption' law for Lattice"
  quickCheck absorption

  log "Checking 'Idempotent' law for Lattice"
  quickCheck idempotent

  where

  associativity :: a -> a -> a -> Boolean
  associativity a b c = (a || (b || c)) == ((a || b) || c)
                     && (a && (b && c)) == ((a && b) && c)

  commutativity :: a -> a -> Boolean
  commutativity a b = (a || b) == (b || a)
                   && (a && b) == (b && a)

  absorption :: a -> a -> Boolean
  absorption a b = (a || (a && b)) == a
                && (a && (a || b)) == a

  idempotent :: a -> Boolean
  idempotent a = (a || a) == a
              && (a && a) == a
  
  identity :: a -> Boolean
  identity a = (a || bottom) == a
            && (a && top) == a

  annihiliation :: a -> Boolean
  annihiliation a = (a || top) == top
                 && (a && bottom) == bottom
                 
  complemented :: a -> Boolean
  complemented a = (not a || a) == top
                && (not a && a) == bottom

  doubleNegation :: a -> Boolean
  doubleNegation a = (not <<< not) a == id a

  distributivity :: a -> a -> a -> Boolean
  distributivity x y z = (x && (y || z)) == ((x && y) || (x && z))