package com.forge.fex.verilogprime.ext;

import java.util.Map;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.ExpressionContext;
import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Named_port_connectionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Named_port_connectionContextExt extends AbstractBaseExt {

	public Named_port_connectionContextExt(Named_port_connectionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Named_port_connectionContext getContext() {
		return (Named_port_connectionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).named_port_connection());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Named_port_connectionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Named_port_connectionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void collectDeclaredPortConnections(Map<String, ExpressionContext> ports) {
		Named_port_connectionContext ctx = getContext();
		if (ctx.string_literal() != null) {
			AbstractBaseExt.L.error("This is for regex support. Not handled yet.");
		}
		String name = ctx.port_identifier().extendedContext.getFormattedText();
		ports.put(name, ctx.expression());
	}
}
