package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_declarationContextExt extends AbstractBaseExt {

	public Udp_declarationContextExt(Udp_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_declarationContext getContext() {
		return (Udp_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Udp_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}