module VectorBuilder.Private.Builder
where

import VectorBuilder.Private.Prelude
import qualified VectorBuilder.Private.Action as A
import qualified Data.Vector as B


-- |
-- An abstraction over the size of a vector for the process of its construction.
-- 
-- It postpones the actual construction of a vector until the execution of the builder.
newtype Builder element =
  Builder (forall s. A.Action s element ())

-- |
-- Provides support for /O(1)/ concatenation.
instance Monoid (Builder element) where
  mempty =
    VectorBuilder.Private.Builder.empty
  mappend =
    prepend

-- |
-- Provides support for /O(1)/ concatenation.
instance Semigroup (Builder element) where
  (<>) =
    prepend


-- * Initialisation

-- |
-- Empty builder.
empty :: Builder element
empty =
  Builder (pure ())

-- |
-- Builder of a single element.
singleton :: element -> Builder element
singleton element =
  Builder (A.snoc element)

-- |
-- Builder from a vector of elements.
vector :: B.Vector element -> Builder element
vector vector =
  Builder (A.append vector)


-- * Updates

snoc :: element -> Builder element -> Builder element
snoc element (Builder action) =
  Builder (action *> A.snoc element)

cons :: element -> Builder element -> Builder element
cons element (Builder action) =
  Builder (A.snoc element *> action)

prepend :: Builder element -> Builder element -> Builder element
prepend (Builder action1) (Builder action2) =
  Builder (action1 *> action2)

append :: Builder element -> Builder element -> Builder element
append (Builder action1) (Builder action2) =
  Builder (action1 <* action2)
