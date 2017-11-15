(define (domain monkey-domain)
(:requirements :strips :equality)
(:constants monkey box bananas high low)
(:predicates (location ?x)
             (height ?m ?x)
             (at ?m ?x)
             (hasbananas))

(:action Go
  :parameters (?x ?y)
  :precondition (and (location ?x) (location ?y) -- (not (= ?x ?y)) 
                (height monkey low) (at monkey ?x ))
  :effect (and (at monkey ?y) (not (at monkey ?x))))

(:action ClimbUp
  :parameters  (?x)
  :precondition (and (location ?x) (at box ?x) (at monkey ?x) (height monkey low))
  :effect (and (height monkey high) (not (height monkey low))))

(:action ClimbDown
  :parameters  (?x)
  :precondition (and (location ?x) (at box ?x) (at monkey ?x) (height monkey high))
  :effect (and (height monkey low) (not (height monkey high))))

(:action Grasp
  :parameters  (?x)
  :precondition (and  (location ?x) (at bananas ?x)(at monkey ?x)(height monkey high))
  :effect (and (hasbananas)))

(:action Push
  :parameters  (?x ?y)
  :precondition (and  (location ?x) (location ?y)(not (= ?x ?y))(at box ?y)
                (at monkey ?y)(height monkey low))
  :effect (and (at monkey ?x) (not (at monkey ?y))(at box ?x)(not(at box ?y))))
