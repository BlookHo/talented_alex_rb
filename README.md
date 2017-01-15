
## This is my solution for TextMaster's coding test. See [Test content][] (test_text)


##Requirements

  * Ruby 2.3.1
  * Bundler

##Concept

Main idea from task text: __it needs to be flexible regarding pricing rules__ .

Each rule is previously created, should be validated and stored in JSON file `rules.json` in specific format.

Each rule consists of following data:
  * title
  * conditions
  * cart_actions
  * pricing_actions
  
Conditions, cart_actions and product_pricing - can be multiple in one rule.
Each rule can be applied to product cart when all conditions fulfilled.

Possible `conditions ` of one rule's apply are: __more__, __more_and_equal__, __less_and_equal__,
__less__ and __equal__. Stored in constant COMPARE_METHODS.

Possible one rule's `cart_actions ` are: __add__, __multiply__ and __set_to__. 
Stored in constant ACTIONS_METHODS.

Possible `product_pricing ` of one rule are following: __discount__, __set_to__,
__less_to__ and __divide__.

__todo:__ Each new rule should be validate when created and stored in JSON file.

Products data is stored in JSON file `products.json`, being previously created and validated.

Rules and products data can be added, changed and deleted by appropriate UI,
which developing is not a subject of this task.

Method scan involves cart content update and try to execute appropriate pricing rules.
Each rule can be applied to cart content if its apply conditions are satisfied.
In this case rule is executed and cart content as well cart prices can be updated 
according to rule content: e.g. add products to cart and/or make a discount to products price.

##Usage

  Run in project folder __source 'start.rb'__
  
  API calls:
```
co = Checkout.new(pricing_rules)
co.scan(item)
co.scan(item)
price = co.total

```


##### [Test content] (test_text)----------------------------------------------------------------------

TextMaster's quest for global domination has prompted us to open a supermarket - we sell only three products:

```
+--------------|--------------|---------+
| Product Code |     Name     |  Price  |
+--------------|--------------|---------+
|     FR1      |   Fruit tea  |  $3.11  |
|     AP1      |   Apple      |  $5.00  |
|     CF1      |   Coffee     | $11.23  |
+--------------|--------------|---------+
```
Our CEO is a big fan of buy-one-get-one-free offers and of fruit tea. He wants us to add a rule to do this.

The COO, though, likes low prices and wants people buying apple to get a price 
discount for bulk purchases. If you buy 3 or more apple, the price should drop to $4.50.
Our check-out can scan items in any order, and because the CEO and COO change 
their minds often, __it needs to be flexible regarding our pricing rules__.

The interface to our checkout looks like this (shown in Ruby):

```
co = Checkout.new(pricing_rules)
co.scan(item)
co.scan(item)
price = co.total
```
Implement a checkout system that fulfils these requirements in Ruby.

Here are some test data:

```
Basket 1: FR1, AP1, FR1, CF1
Total price expected: $22.25
```

```
Basket 2: FR1, FR1
Total price expected: $3.11
```

```
Basket 3: AP1, AP1, FR1, AP1
Total price expected: $16.61
```

PS: Add specs

##### --- end of task text -------------------------------------------------------------------

I have to notice that IMHO some of the following test baskets, provided by TextMaster - have errors.
If basket presented above represent final basket content, i.e. after pricing rules applying,
first basket content should be:

```
Basket 1 ruled out content: FR1, FR1, AP1, FR1, FR1, CF1
Total price expected: $22.45
```
First rule (with FR1) will add one free FR1 to the cart after this product scanning.
According to Rule#1 FR1 price should be 1.555.
So, final total price of this basket is incorrect and should be: 22.45

Second basket is also incorrect. Having scanned FR1 and Ruke#1 evaluate increasing of basket content with second FR1.
Finally this basket total price is 6.22. 
```
Basket 2 ruled out content: FR1, FR1, FR1, FR1
Total price expected: $6.22
```

Third basket is incorrect.
Scanning of FR1 will also involve Rule#1 applying. So, this basket content should be:

```
Basket 3 ruled out content: AP1, AP1, FR1, FR1, AP1
Total price expected: $16.61
```
Total price is correct.

