# AirBnb Database 
## Apply Normalisation  principle (1NF, 2NF, 3NF)

### Apply 1NF - First normal forms
<p> Entity Separation </p>

```user entity``` <br/>
```property entity``` <br/>
```booking entity```<br/>
```review entity```<br/>
```payment entity``` <br/>
```message entity```

<pre>
Remark: each entity contains unique data, no column should contain a list or array values
</pre>

### Apply 2NF - Second normal forms
<p> Enity separation with no dependancy: </p>

- ```user entity```: Must contain only user data,  <code>id: [primary key]</code> <br/>

- ```property entity```: Must contain only property data,  <code>id: [primary key]</code>, <code>host_id [foreign key]</code>.<br/>

- ```booking entity```: Must contain only booking data,  <code>id: [primary key]</code>, <code>user_id [foreign key]</code><br/>

- ```review entity```: Must contain only review data,  <code>id: [primary key]</code>, <code>user_id [foreign key]</code> <code>property_id [foreign key]</code><br/>

- ```payment entity```: Must contain only payment data,  <code>id: [primary key]</code>, <code>booking_id [foreign key]</code><br/>

- ```message entity```: Must contain only message data,  <code>id: [primary key]</code>, <code>sender_id [foreign key]</code> <code>recipient_id [foreign key]</code>

<pre>
Remark: relationships must be enforced using foreign keys, no duplicate data (1NF) applied</pre>

### Apply 3NF - Third normal forms
<p>No Transitive Dependencies</p>

#### *Remove <code>total_price</code> from Booking table
#### *Add <code>locked_pricepernight</code> for scalability and audit tracking

<pre>
Remark: 
- Upholds 3NF by eliminating derived data.
- Scales better for real-world financial systems.
- Simplifies audits with immutable price snapshots</pre>