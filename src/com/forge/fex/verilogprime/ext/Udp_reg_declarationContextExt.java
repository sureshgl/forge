package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Udp_reg_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Udp_reg_declarationContextExt extends AbstractBaseExt {

	public Udp_reg_declarationContextExt(Udp_reg_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Udp_reg_declarationContext getContext() {
		return (Udp_reg_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).udp_reg_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Udp_reg_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Udp_reg_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}