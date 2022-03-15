{-

Definition and properties of finite sets equipped with finite structures,
namely the type of structures over a given finte set is a finite set.

-}
{-# OPTIONS --safe #-}

module Cubical.Data.FinSet.FiniteStructure where

open import Cubical.Foundations.Prelude
open import Cubical.Foundations.Isomorphism
open import Cubical.Foundations.Equiv renaming (_∙ₑ_ to _⋆_)

open import Cubical.HITs.PropositionalTruncation as Prop
open import Cubical.HITs.SetTruncation as Set

open import Cubical.Data.Nat
open import Cubical.Data.Sigma

open import Cubical.Data.FinSet.Base
open import Cubical.Data.FinSet.Properties
open import Cubical.Data.FinSet.Induction
open import Cubical.Data.FinSet.Constructor
open import Cubical.Data.FinSet.Cardinality
open import Cubical.Data.FinSet.FiniteType

private
  variable
    ℓ ℓ' : Level
    n : ℕ
    S : FinSet ℓ → FinSet ℓ'

-- type of finite sets with finite structure

FinSetWithStr : (ℓ : Level) (S : FinSet ℓ → FinSet ℓ') → Type (ℓ-max (ℓ-suc ℓ) ℓ')
FinSetWithStr ℓ S = Σ[ X ∈ FinSet ℓ ] S X .fst

-- type finite sets of a given cardinal

FinSetOfCard : (ℓ : Level) (n : ℕ) → Type (ℓ-suc ℓ)
FinSetOfCard ℓ n = Σ[ X ∈ FinSet ℓ ] (card X ≡ n)

FinSetWithStrOfCard : (ℓ : Level) (S : FinSet ℓ → FinSet ℓ') (n : ℕ) → Type (ℓ-max (ℓ-suc ℓ) ℓ')
FinSetWithStrOfCard ℓ S n = Σ[ X ∈ FinSetOfCard ℓ n ] S (X .fst) .fst

FinSetOfCard≡ : (X Y : FinSetOfCard ℓ n) → (X .fst ≡ Y .fst) ≃ (X ≡ Y)
FinSetOfCard≡ _ _ = Σ≡PropEquiv (λ _ → isSetℕ _ _)

open Iso

∥FinSetOfCard∥₂≡ : (X Y : FinSetOfCard ℓ n) → ∥ X .fst ≡ Y .fst ∥ → ∣ X ∣₂ ≡ ∣ Y ∣₂
∥FinSetOfCard∥₂≡ _ _ =
  Prop.rec (squash₂ _ _) (λ p → PathIdTrunc₀Iso .inv ∣ FinSetOfCard≡ _ _ .fst p ∣)

isPathConnectedFinSetOfCard : isContr ∥ FinSetOfCard ℓ n ∥₂
isPathConnectedFinSetOfCard {n = n} .fst = ∣ 𝔽in n , card𝔽in n ∣₂
isPathConnectedFinSetOfCard {n = n} .snd =
  Set.elim (λ _ → isProp→isSet (squash₂ _ _)) (λ (X , p) → sym (∥FinSetOfCard∥₂≡ _ _ (card≡n p)))

isFinTypeFinSetOfCard : isFinType 1 (FinSetOfCard ℓ n)
isFinTypeFinSetOfCard .fst = isPathConnected→isFinType0 isPathConnectedFinSetOfCard
isFinTypeFinSetOfCard .snd X Y =
  isFinSet→isFinType 0 (EquivPresIsFinSet (FinSet≡ _ _ ⋆ FinSetOfCard≡ _ _) (isFinSetType≡Eff (X .fst) (Y .fst)))

isFinTypeFinSetWithStrOfCard : (ℓ : Level) (S : FinSet ℓ → FinSet ℓ') (n : ℕ)
  → isFinType 0 (FinSetWithStrOfCard ℓ S n)
isFinTypeFinSetWithStrOfCard ℓ S n =
  isFinTypeΣ {n = 0} (_ , isFinTypeFinSetOfCard) (λ X → _ , isFinSet→isFinType 0 (S (X .fst) .snd))
