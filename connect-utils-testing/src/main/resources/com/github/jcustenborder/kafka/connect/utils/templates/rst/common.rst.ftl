<#-- @formatter:off -->
<#macro section text>
<#list 0..<text?length as i>=</#list>
${text}
<#list 0..<text?length as i>=</#list>
</#macro>

<#macro subsection text>
<#list 0..<text?length as i>-</#list>
${text}
<#list 0..<text?length as i>-</#list>
</#macro>

<#macro subsubsection text>
<#list 0..<text?length as i>^</#list>
${text}
<#list 0..<text?length as i>^</#list>
</#macro>

<#macro configProperties className requiredConfigs>

This configuration is used typically along with `standalone mode
<http://docs.confluent.io/current/connect/concepts.html#standalone-workers>`_.

.. code-block:: properties

    name=connector1
    tasks.max=1
    connector.class=${className}
    # The following values must be configured.
<#list requiredConfigs as item>
    ${item.name()}=
</#list>


</#macro>

<#macro configJson className requiredConfigs>

This configuration is used typically along with `distributed mode
<http://docs.confluent.io/current/connect/concepts.html#distributed-workers>`_.
Write the following json to `connector.json`, configure all of the required values, and use the command below to
post the configuration to one the distributed connect worker(s).

.. code-block:: json

    {
        "name": "connector1",
        "config": {
            "connector.class": "${className}",
            <#list requiredConfigs as item>
            "${item.name()}":"",
            </#list>
        }
    }

Use curl to post the configuration to one of the Kafka Connect Workers. Change `http://localhost:8083/` the the endpoint of
one of your Kafka Connect worker(s).

.. code-block:: bash

    curl -s -X POST -H 'Content-Type: application/json' --data @connector.json http://localhost:8083/connectors



</#macro>

<#macro tableBar columnLengths column character="-"><#list 0..<columnLengths[column] as i>${character}</#list></#macro>
<#macro headerBar columnLengths column character="="><#list 0..<columnLengths[column] as i>${character}</#list></#macro>

<#macro tablePadText columnLengths column text><#assign pad=columnLengths[column] -1><#if text??> ${text?right_pad(pad)}<#else>${" "?right_pad(pad)}</#if></#macro>

<#macro configTable configs lengths>
+<@tableBar columnLengths=lengths column="name" />+<@tableBar columnLengths=lengths column="type" />+<@tableBar columnLengths=lengths column="importance" />+<@tableBar columnLengths=lengths column="defaultValue" />+<@tableBar columnLengths=lengths column="validator" />+<@tableBar columnLengths=lengths column="doc" />+
<#list configs as config>
|<@tablePadText columnLengths=lengths column="name" text=config.name() />|<@tablePadText columnLengths=lengths column="type" text=":ref:`configuration-${config.type()}`" />|<@tablePadText columnLengths=lengths column="importance" text=config.importance() />|<@tablePadText columnLengths=lengths column="defaultValue" text=config.defaultValue() />|<@tablePadText columnLengths=lengths column="validator" text=config.validator() />|<@tablePadText columnLengths=lengths column="doc" text=config.doc() />|
+<@tableBar columnLengths=lengths column="name" />+<@tableBar columnLengths=lengths column="type" />+<@tableBar columnLengths=lengths column="importance" />+<@tableBar columnLengths=lengths column="defaultValue" />+<@tableBar columnLengths=lengths column="validator" />+<@tableBar columnLengths=lengths column="doc" />+
</#list>
</#macro>

<#macro configExamples input>
<@subsection text="Configuration"/>

${rstHelper.table(input.config)}

<@subsubsection text="Property based example" />

<@configProperties className=input.className requiredConfigs=input.config.requiredConfigs />

<@subsubsection text="Rest based example" />

<@configJson className=input.className requiredConfigs=input.config.requiredConfigs />
</#macro>

<#macro notes input>

<#if input.danger??>
.. DANGER::
    ${input.danger}


</#if><#if input.warning??>
.. WARNING::
    ${input.warning}


</#if><#if input.important??>
.. IMPORTANT::
    ${input.important}


</#if><#if input.tip??>
.. TIP::
    ${input.tip}


</#if><#if input.note??>
.. NOTE::
    ${input.note}


</#if>
</#macro>
