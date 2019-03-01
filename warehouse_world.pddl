(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
    
    (:action robotMove 
      :parameters (?r - robot ?start - location ?end - location)
      :precondition (and (at ?r ?start) (connected ?start ?end) (no-robot ?end))
      :effect (and (at ?r ?end) (not (at ?r ?start)) (not (no-robot ?end)) (no-robot ?start))
    )
    
    (:action robotMoveWithPallette
      :parameters (?r - robot ?start - location ?end - location ?p - pallette)
      :precondition (and (at ?r ?start) (at ?p ?start) (connected ?start ?end) (no-robot ?end) (no-pallette ?end))
      :effect (and (not (at ?r ?start)) (not (at ?p ?start)) (at ?r ?end) (at ?p ?end) (not (no-robot ?end)) (not (no-pallette ?end)) (no-robot ?start) (no-pallette ?start)) 
    )
    
    (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?shipment - shipment ?item - saleitem ?p - pallette ?order - order)
      :precondition (and (ships ?shipment ?order) (orders ?order ?item) (started ?shipment) (not (complete ?shipment)) (not(no-pallette ?l)) (contains ?p ?item) (at ?p ?l) (packing-at ?shipment ?l))
      :effect (and (not (contains ?p ?item)) (includes ?shipment ?item)) 
    )
    
    (:action completeShipment
      :parameters (?l - location ?shipment - shipment ?order - order)
      :precondition (and (ships ?shipment ?order) (started ?shipment))
      :effect (and (not (started ?shipment)) (complete ?shipment) (not (packing-at ?shipment ?l)) (available ?l)) 
    )

)
