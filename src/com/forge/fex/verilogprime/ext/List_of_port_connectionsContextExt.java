package com.forge.fex.verilogprime.ext;

import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExpressionContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_port_connectionsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_port_connectionsContextExt extends AbstractBaseExt {

	public List_of_port_connectionsContextExt(List_of_port_connectionsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_port_connectionsContext getContext() {
		return (List_of_port_connectionsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_port_connections());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_port_connectionsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_port_connectionsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void collectDeclaredPortConnections(Map<String, ExpressionContext> ports) {
		List_of_port_connectionsContext ctx = getContext();
		if (ctx.ordered_port_connection() != null && ctx.ordered_port_connection().size() > 0
				&& ctx.ordered_port_connection().get(0).getText().length() > 0) {
			AbstractBaseExt.L.error("Ordered port connections ecountered");
		} else {
			super.collectDeclaredPortConnections(ports);
		}
	}
}