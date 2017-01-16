
## This is my solution for TextMaster's coding test. Test text - [here](#test)


##Requirements

  * Ruby 2.3.1
  * Bundler

##Concept

Main idea from task text: __it needs to be flexible regarding pricing rules__ .

Each rule was created before running the program and should be validated and stored in JSON file `rules.json` in specific format.

Each rule consists of the following data:
  * title
  * conditions
  * cart_actions
  * pricing_actions
  
Conditions, cart_actions and product_pricing - can have multiple occurances in one rule.
Each rule can be applied to a product cart when all conditions are fulfilled.


Possible `conditions ` of one rule's apply are: __more__, __more_and_equal__, __less_and_equal__,
__less__ and __equal__. They are stored in a constant COMPARE_METHODS.

Possible one rule's `cart_actions ` are: __add__, __multiply__ and __set_to__. 
They are stored in a constant ACTIONS_METHODS.

Possible `pricing_actions ` of a rule are the following: __set_to__, __less_to__ and __divide__.
They are stored in a constant PRICING_METHODS.

__TODO:__ Each new rule should be validated when being created and stored in JSON file.



Products data is stored in JSON file `products.json`, and is being created and validated before running the program.


##Usage

  Run in project folder: __source 'start.rb'__
  
  App usage example:
  
```
co = Checkout.new(pricing_rules)
co.scan(item)
co.scan(item)
price = co.total

``` 
Method __co.scan(item)__ involves cart content update and try to execute appropriate pricing rules.
Each rule can be applied to cart content if it's apply conditions are satisfied.
In this case rule is executed and cart content is updated - scanned product is added to cart.
At the same time cart prices can be updated as well, according to rule content and actions.
E.g. make a discount to product price.

After product being scanned - it will be added to cart, with appropriate price.
Total cart price can be retieved with __co.total__ call.

If scanned  product is unknown- it will be added to cart, but with zero price.
In this case message "Price to be determined" is shown and total cart price 
does not include price of unknown product.

Rspec tests run in project folder: __bundle exec rspec__



## TextMaster's test content<a name="test"></a> --------------------------------------

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

### --- end of task text ------------------------------------------------------------------



### --- My notes to task content -----------------------------------------------------


I have to notice that IMHO some of the following test baskets, provided by TextMaster - have errors.
If baskets from this task text shown above, represent final basket content, i.e. after pricing rules applying,
first basket content should be:

```
Basket 1 ruled out content: FR1, FR1, AP1, FR1, FR1, CF1
Total price expected: $22.45
```
First rule (with the product :FR1) will add one free :FR1 to the cart after this product scanning.
According to Rule#1 :FR1 price should be 50% less, i.e. 1.555.
So, final total price of this basket is incorrect and should be: 22.45

Second basket is also incorrect. Having scanned :FR1 and Rule#1 evaluate increasing of basket content with second free :FR1.
Finally this basket total price will be 6.22. 
```
Basket 2 ruled out content: FR1, FR1, FR1, FR1
Total price expected: $6.22
```

Third basket is incorrect.
Scanning of :FR1 will also involve Rule#1 applying. So, this basket content should be:

```
Basket 3 ruled out content: AP1, AP1, FR1, FR1, AP1
Total price expected: $16.61
```
Third basket total price is correct.

