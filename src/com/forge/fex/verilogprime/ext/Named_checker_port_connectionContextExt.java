package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Named_checker_port_connectionContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Named_checker_port_connectionContextExt extends AbstractBaseExt {

	public Named_checker_port_connectionContextExt(Named_checker_port_connectionContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Named_checker_port_connectionContext getContext() {
		return (Named_checker_port_connectionContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).named_checker_port_connection());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Named_checker_port_connectionContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Named_checker_port_connectionContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}